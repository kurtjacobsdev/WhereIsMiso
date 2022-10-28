//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import UIKit
import ui_common

protocol LoginViewControllerDelegate: AnyObject {
    func didCompleteLogin()
    func didCompleteLogout()
}
 
class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?
    private var passwordField: RoundedTextField = RoundedTextField()
    private var emailField: RoundedTextField = RoundedTextField()
    private var signinButton: AnimatedButton = AnimatedButton()
    private var signOutButton: AnimatedButton = AnimatedButton()
    private var messageImageView: UIImageView = UIImageView()
    private var messageLabel: UILabel = UILabel()
    private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", image: nil, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem?.tintColor = .systemPurple
        self.view.backgroundColor = .systemGroupedBackground
        configureHierarchy()
        configureConstraints()
        configureStyling()
        configureProperties()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureHierarchy() {
        self.view.addSubview(passwordField)
        self.view.addSubview(emailField)
        self.view.addSubview(signinButton)
        self.view.addSubview(signOutButton)
        self.view.addSubview(messageLabel)
        self.view.addSubview(messageImageView)
    }
    
    private func configureStyling() {
        signinButton.configure(configuration: AnimatedButtonConfiguration(title: "Sign In", color: .systemPurple))
        signOutButton.configure(configuration: AnimatedButtonConfiguration(title: "Sign Out", color: .systemPurple))
        emailField.backgroundColor = AppColor.primary
        emailField.layer.cornerRadius = 25
        emailField.placeholder = "Please Enter Your Email"
        emailField.textAlignment = .center
        passwordField.backgroundColor = AppColor.primary
        passwordField.layer.cornerRadius = 25
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Please Enter The Secret Code"
        passwordField.textAlignment = .center
        signinButton.isHidden = viewModel.isLoggedIn()
        passwordField.isHidden = viewModel.isLoggedIn()
        emailField.isHidden = viewModel.isLoggedIn()
        messageLabel.isHidden = !viewModel.isLoggedIn()
        messageImageView.isHidden = !viewModel.isLoggedIn()
        signinButton.isHidden = viewModel.isLoggedIn()
        signOutButton.isHidden = !viewModel.isLoggedIn()
        messageLabel.text = viewModel.isMiso() ? "You Are Miso Lubarda!" : "You Are Apple!"
        messageImageView.image = UIImage(named: viewModel.isMiso() ? "misoButton" : "apple", in: Bundle.module, with: nil)
    }
    
    private func configureProperties() {
        signinButton.addTarget(target: self, action: #selector(signIn), for: .touchUpInside)
        signOutButton.addTarget(target: self, action: #selector(signOut), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        signinButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(88)
        }
        
        signOutButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(88)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(66)
        }
        
        emailField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(66)
        }
        
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview().inset(40)
        }
        
        messageImageView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
    }
    
    @objc func signIn() {
        signinButton.startAnimating()
        Task {
            do {
                try await viewModel.login(email: emailField.text ?? "", password: passwordField.text ?? "")
                signinButton.stopAnimating()
                delegate?.didCompleteLogin()
                close()
            } catch {
                let alert = UIAlertController(title: "Login Failed", message: "Please check your password or email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                signinButton.stopAnimating()
            }
        }
    }
    
    @objc func signOut() throws {
        try viewModel.logout()
        delegate?.didCompleteLogout()
        close()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
}
