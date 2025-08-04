//
//  HomeVC.swift
//  AppFinances
//
//  Created by Edgar on 27/06/25.
//

import UIKit
import Combine
import Photos
import PhotosUI

class HomeVC: UIViewController {
    
    private let contentView: HomeView
    private let viewModel: HomeViewModel
    private var pageVC: UIPageViewController?
    private var previousMonthYear: AFMonthYear = .from(date: .now)
    
    private weak var flowDelegate: HomeCoordinate?
    private var cancellable = Set<AnyCancellable>()
    
    let viewControllersFactory = AFViewControllersFactory()
    
    init(contentView: HomeView, viewModel: HomeViewModel, flowDelegate: HomeCoordinate? = nil) {
        self.contentView = contentView
        self.flowDelegate = flowDelegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        contentView.monthSelector.centerToCurrentDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func setup(){
        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView, safe: false)
        bindPublishers()
        setupChildPageView()
        setupAction()
        setupHeader()
    }
    
    private func setupHeader(){
        setupPickPhotoAction()

        contentView.headerView.usernameTextField.delegate = self
        
        if let username = viewModel.user?.name {
            contentView.headerView.usernameTextField.text = username
        }
        
        if let userPhoto = viewModel.getUserPhoto() {
            contentView.headerView.avatarImageView.image = userPhoto
        }
    }
    
      
    private func setupPickPhotoAction(){
        contentView.headerView.avatarImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        contentView.headerView.avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func openImagePicker(){
        let alertController = UIAlertController(title: "Selecionar foto", message: nil, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: "Galeria",
                style: .default,
                handler: { _ in self.pickFromPhotos() }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Camera",
                style: .default,
                handler: { _ in self.pickFromCamera() }
            )
        )
        alertController.addAction(UIAlertAction(title: "Voltar", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func pickFromCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true)
    }
    
    private func pickFromPhotos(){
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.selectionLimit = 1
        phPickerConfiguration.filter = PHPickerFilter.any(of: [.images,.livePhotos])
        let phPicker = PHPickerViewController(configuration: phPickerConfiguration)
        phPicker.delegate = self
        present(phPicker, animated: true)
    }
    
    private func saveUserPhoto(image: UIImage){
        DispatchQueue.main.dispatchMainIfNeeded {
            self.contentView.headerView.avatarImageView.image = image
        }
        viewModel.saveUserPhoto(image: image)
    }
    
    private func setupChildPageView(){
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageVC)
        contentView.entriesContainerView.addSubview(pageVC.view)
        pageVC.view.frame = contentView.entriesContainerView.bounds
        pageVC.didMove(toParent: self)
        pageVC.dataSource = self
        pageVC.delegate = self
        self.pageVC = pageVC
    }
    
    private func bindPublishers(){
        contentView.monthSelector.monthYearPublisher
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] monthYear in
                self?.updatePageView(with: monthYear)
            }
            .store(in: &cancellable)
    }
    
    private func getPageViewDirection(
        from monthYear:AFMonthYear,
        previous previousMonthYear: AFMonthYear
    ) -> UIPageViewController.NavigationDirection? {
        
        guard let previousDate = previousMonthYear.date else {
            return nil
        }
        
        self.previousMonthYear = monthYear
        
        if monthYear.isAfter(date: previousDate){
            return .forward
        }
        
        return .reverse
    }
    
    private func updatePageView(with monthYear: AFMonthYear){
        let direction = getPageViewDirection(from: monthYear, previous: previousMonthYear)
        
        let viewController = viewControllersFactory.makeEntriesVC(monthYear: monthYear, flowDelegate: flowDelegate)
        
        pageVC?.setViewControllers(
            [viewController],
            direction: direction ?? .forward,
            animated: direction != nil
        )
    }
    
    private func setupAction(){
        contentView.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        contentView.headerView.logoutImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLogout)))
    }
    
    @objc
    private func didTapActionButton(){
        flowDelegate?.presentAddEntryVC(delegate: self)
    }
    
    @objc
    private func didTapLogout(){
        let alertVC = UIAlertController(title: "Atenção", message: "Deseja mesmo sair?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Voltar", style: .cancel))
        alertVC.addAction(UIAlertAction(
            title: "Sair",
            style: .destructive,
            handler: { [weak self] _ in self?.logout() }
       ))
        
        present(alertVC, animated: true)
    }
}

extension HomeVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard
            let entriesVC = viewController as? AFEntriesVC,
            let previousMonthYear = entriesVC.monthYear.previous()
        else {
            return nil
        }
        
        return viewControllersFactory.makeEntriesVC(monthYear: previousMonthYear, flowDelegate: flowDelegate)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let entriesVC = viewController as? AFEntriesVC,
            let nextMonthYear = entriesVC.monthYear.next()
        else {
            return nil
        }
        
        return viewControllersFactory.makeEntriesVC(monthYear: nextMonthYear, flowDelegate: flowDelegate)
    }
    
    private func logout(){
        Task { [weak self] in
            guard let self else {
                return
            }
            do {
                try await viewModel.logout()
                flowDelegate?.resetToSplash()
            } catch {
                print(error)
            }
        }
    }
}

extension HomeVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
        guard
            finished,
            completed,
            let entriesVC = pageViewController.viewControllers?.first as? AFEntriesVC
        else {
            return
        }
        
        contentView.monthSelector.setMonthYear(entriesVC.monthYear)
    }
}

extension HomeVC: AddEntryDelegate {
    func didCreateNewEntry(_ entry: AFEntry) {
        guard
            let entryVC = pageVC?.viewControllers?.first as? AFEntriesVC,
            entryVC.monthYear == .from(date: entry.dueAt)
        else {
            return
        }
        
        entryVC.load()
    }
}

extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            saveUserPhoto(image: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            saveUserPhoto(image: originalImage)
        }
        self.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

extension HomeVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                self.saveUserPhoto(image: image)
            }
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let displayName = textField.text {
            viewModel.updateDisplayName(displayName)
        }
        return true
    }
}

protocol HomeCoordinate: PresentAddEntryProtocol, PresentAddBudgetProtocol {
    func resetToSplash()
}
