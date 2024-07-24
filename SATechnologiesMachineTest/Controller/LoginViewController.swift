//
//  ViewController.swift
//  SATechnologiesMachineTest
//
//  Created by Ganesh Pawar on 07/07/24.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var isLogInSelected = true
    
    //MARK: - Properties
    let viewModel = LoginViewModel()
    
    //MARK: - View Controller Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - IBActions
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isLogInSelected = true
            loginButton.setTitle(Constant.TitleString.login, for: .normal)
        default:
            isLogInSelected = false
            loginButton.setTitle(Constant.TitleString.signUp, for: .normal)
        }
        clearTextField()
    }
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if let email = emailTextField.text, !email.isEmpty {
            if email.isEmailValid {
                if let password = passwordTextField.text, !password.isEmpty {
                    if password.count >= 8 {
                        
                        if isLogInSelected {
                            login(email: email, password: password)
                        } else {
                            signUp(email: email, password: password)
                        }
                    } else {
                        CustomAlertController.present(title: "Insecure Password", message: "Password should be atleast 8 characters long to be strong")
                    }
                } else {
                    CustomAlertController.present(title: "Password missing", message: "Please enter password")
                }
            } else {
                CustomAlertController.present(title: "Incorrect Email", message: "Enter valid email address")
            }
        } else {
            CustomAlertController.present(title: "Email is missing", message: "Please enter email address")
        }
    }
    
    // MARK: - API methods
    
    func signUp(email: String, password: String) {
        
        let signUpDetails = LoginAPIRequestModel(email: email, password: password)
        self.viewModel.signUpAPI(signUpDetails: signUpDetails) { result in
            switch result {
            case .success:
                CustomAlertController.present(title: "Success", message: "Account created Successfully")
                self.clearTextField()
            case .failure(let error):
                CustomAlertController.present(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func login(email: String, password: String) {
        
        let loginDetails = LoginAPIRequestModel(email: email, password: password)
        
        self.viewModel.loginAPI(loginDetails: loginDetails) { result in
            
            switch result {
            case .success:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: Constant.ViewControllerNames.homeNavigationController)
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            case .failure(let error):
                CustomAlertController.present(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func clearTextField() {
        emailTextField.text = nil
        passwordTextField.text = nil
    }
}

