//
//  AddEntryVC.swift
//  AppFinances
//
//  Created by Edgar on 21/07/25.
//

import UIKit

class AddEntryVC: UIViewController {
    private let contentView: AddEntryView
    
    private let formGroup: AFFormGroup<AddEntryForm>
    private let viewModel: AddEntryViewModel
    weak var flowDelegate: AddEntryFlowDelegate?
    weak var delegate: AddEntryDelegate?
    
    
    init(contentView: AddEntryView, viewModel: AddEntryViewModel) {
        self.contentView = contentView
        self.viewModel = viewModel
        self.formGroup = AFFormGroup(model: AddEntryForm())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView, safe: false)
        
        bindInputs()
        setupAction()
        setupDatePicker()
        setupCategoryPicker()
        
        contentView.valueInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func bindInputs(){
        formGroup.bind(\.description, input: contentView.descriptionTextInput)
        formGroup.bind(\.category, input: contentView.categoryInput)
        formGroup.bind(\.value, input: contentView.valueInput)
        formGroup.bind(\.date, input: contentView.dateInput)
        formGroup.bind(\.type, input: contentView.selectTransactionType)
    }
    
    private func setupAction(){
        contentView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        contentView.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapActionButton(){
  
        Task { [weak self] in
            guard let self else {
                return
            }
            
            guard
                formGroup.validate(),
                let formState = formGroup.getState()
            else {
                return
            }
            
            
            do {
                let newEntry = try await viewModel.createNewEntry(form: formState)
                delegate?.didCreateNewEntry(newEntry)
                flowDelegate?.dismiss()
            } catch AFError.invalidForm {
                showSimpleAlert(title: "Atenção", message: "Por favor verifique os campos do formulário.")
            } catch AFError.unauthorized {
                showSimpleAlert(title: "Atenção", message: "Você não tem autorização para isto.")
            } catch {
                print(error)
                showSimpleAlert(title: "Atenção", message: "Sem permissão")
            }
        }
    }
    
    func showSimpleAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        DispatchQueue.main.dispatchMainIfNeeded { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
    
    @objc
    private func didTapCloseButton(){
        flowDelegate?.dismiss()
    }
    
}

// MARK: Pickers setup
extension AddEntryVC {
    private func setupCategoryPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didSelectCategory))

        toolbar.setItems([doneButton], animated: true)
        contentView.categoryInput.inputView = contentView.categoryPicker
        contentView.categoryInput.inputAccessoryView = toolbar

        contentView.categoryPicker.delegate = self
        contentView.categoryPicker.dataSource = self
    }
    
    @objc
    private func didSelectCategory(){
        contentView.categoryInput.resignFirstResponder()
        let selected = contentView.categoryPicker.selectedRow(inComponent: 0)
        contentView.categoryInput.text = AFEntry.Category.allCases[selected].getTitle()
    }
    
    private func setupDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didSelectDate))

        toolbar.setItems([doneButton], animated: true)
        contentView.dateInput.inputView = contentView.datePicker
        contentView.dateInput.inputAccessoryView = toolbar
    }
    
    @objc
    private func didSelectDate(){
        contentView.dateInput.resignFirstResponder()
        contentView.dateInput.text = contentView.datePicker.date.formatted(.dateTime.day().month(.twoDigits).year())
    }
}

// MARK: Category Picker
extension AddEntryVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        AFEntry.Category.allCases.count
    }
}

extension AddEntryVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AFEntry.Category.getOptions()[row]
    }
}

// MARK: TextField currency formatter
extension AddEntryVC {
    @objc
    private func textFieldDidChange(_ textField: UITextField){
        textField.text = textField.text?.currencyInputFormatting()
    }
}



protocol AddEntryFlowDelegate: DismissProtocol {
    
}


protocol AddEntryDelegate: AnyObject {
    func didCreateNewEntry(_ entry: AFEntry)
}
