//
//  LoginVC.swift
//  App de Finanças
//
//  Created by Edgar on 21/06/25.
//

import UIKit


class LoginVC: UIViewController {
    
    private let contentView: LoginView
    
    private let formGroup: AFFormGroup<LoginForm>
    private let viewModel: LoginViewModel
    private weak var flowDelegate: LoginCoordinate?

    
    init(contentView: LoginView, viewModel: LoginViewModel, flowDelegate: LoginCoordinate? = nil) {
        self.contentView = contentView
        self.viewModel = viewModel
        self.formGroup = AFFormGroup(model: LoginForm())
        self.flowDelegate = flowDelegate
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
        checkBiometricLogin()
    }
    
    private func animate(){
        
        UIView.animate(withDuration: 0.6){ [weak self] in
            guard let self else {
                return
            }
            contentView.welcomeLabel.alpha = 1
            contentView.subtitleLabel.alpha = 1
            contentView.separatorView.alpha = 1
            contentView.usernameInput.alpha = 1
            contentView.emailInput.alpha = 1
            contentView.passwordInput.alpha = 1
            contentView.actionButton.alpha = 1
        }
    }
    
    private func bindInputs(){
        formGroup.bind(\.username, input: contentView.usernameInput)
        formGroup.bind(\.email, input: contentView.emailInput)
        formGroup.bind(\.password, input: contentView.passwordInput)
        
    }
    
    private func setupAction(){
        contentView.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    private func checkBiometricLogin(){
        Task { [weak self] in
            guard let self else {
                return
            }
            do {
                let (email, password) = try await viewModel.checkBiometricLogin()
                contentView.actionButton.isLoading = true
                let _ = try await viewModel.authenticate(form: .init(username: "", email: email, password: password))
                flowDelegate?.navigateToHome()
            } catch {
                print(error)
            }
           
        }
    }
    
    @objc
    private func didTapActionButton(){
        guard
            formGroup.validate(),
            let formState = formGroup.getState()
        else {
            return
        }
        contentView.actionButton.isLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                contentView.actionButton.isLoading = true
                let _ = try await viewModel.authenticate(form: formState)
                
                if viewModel.checkBiometricAvailability() {
                    askUserToUseBiometricLogin(email: formState.email, password: formState.password)
                } else {
                    flowDelegate?.navigateToHome()
                }
           
            } catch {
                print(error.localizedDescription)
            }
            
            contentView.actionButton.isLoading = false
            
        }
    }
    
    private func askUserToUseBiometricLogin(email: String, password: String){
        let alertController = UIAlertController(
            title: "Habilitar Biometria",
            message: "Deseja habilitar login por biometria?",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "Cancelar",
                style: .cancel,
                handler: {  _ in
                    self.flowDelegate?.navigateToHome()
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "Sim, habilitar biometria.",
                style: .default,
                handler: {  _ in
                    self.viewModel.saveUserLoginWithBiometric(email: email, password: password)
                    self.flowDelegate?.navigateToHome()
                }
            )
        )
        
        DispatchQueue.main.dispatchMainIfNeeded {
            self.present(alertController, animated: true)
        }
    }
    
}


protocol LoginCoordinate: AnyObject {
    
    func navigateToHome()
    
}
