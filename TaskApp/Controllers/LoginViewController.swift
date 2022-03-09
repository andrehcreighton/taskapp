//
//  ViewController.swift
//  TaskApp
//
//  Created by Andre Creighton on 3/24/21.
//

import UIKit
import Firebase
import ProgressHUD

protocol LoginViewProtocol {
  
  func isUserLoggedIn()
  
}

final class LoginViewController: UIViewController {
  
  private var uid = ""
  
  @IBOutlet weak var loginButton: UIButton! {
    didSet{
      loginButton.setTitle("Login", for: .normal)
      loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
  }
  
  @IBOutlet weak var registerButton: UIButton! {
    didSet{
      registerButton.setTitle("Register", for: .normal)
      registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
  }
  
  @IBOutlet weak var emailTF: UITextField! {
    didSet{
      emailTF.text = ""
      emailTF.delegate = self
      emailTF.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
    }
  }
  @IBOutlet weak var passwordTF: UITextField!  {
    didSet{
      passwordTF.text = ""
      passwordTF.isSecureTextEntry = true
      passwordTF.delegate = self
      passwordTF.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
    }
  }
  
  @objc
  private func handleEditing(){
    if let password = passwordTF.text, let email = emailTF.text {
//      print(Utilities.isEmailValid(email), Utilities.isPasswordValid(password))
      enableLogin(Utilities.isEmailValid(email) && Utilities.isPasswordValid(password) ? true : false)
      }
  }
  
  
  @objc
  private func handleLogin(){
    //Firebase Auth log in
    actionProgressStart()
    let password = passwordTF.text!
    let email = emailTF.text!
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error  in
      if let error = error, let authErrorCode = AuthErrorCode(rawValue: error._code){
        ProgressHUD.dismiss()
        self?.alert(authErrorCode.errorMessage)
      }else{
        // login successful
      }
    }
  }
  
  private func alert(_ message: String){
    
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(ok)
    present(alertController, animated: true, completion: nil)
    
  }
  
  @objc
  private func handleRegister(){
    // Go to Register View
    let controller = RegisterViewController.fromStoryboard()
    controller.registeredUserDelegate = self
    present(controller, animated: true, completion: nil)
    
  }
  
  private func enableLogin(_ bool: Bool){
    loginButton.isEnabled = bool
  }
  
  private func actionProgressStart() {

    ProgressHUD.animationType = .circleStrokeSpin
    ProgressHUD.colorProgress = .systemBlue
    ProgressHUD.show()

  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMain" {
      let mainVC = segue.destination as! TasksMainViewController
      mainVC.uid = uid
    }
  }
  
  private func navigationBarSetup(){
    navigationItem.title = "TaskApp"
    // to add attibuted string for title
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    enableLogin(false)
    isUserLoggedIn()
    navigationBarSetup()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    emailTF.text = ""
    passwordTF.text = ""
    ProgressHUD.dismiss()
    
  }
  
}


extension LoginViewController : LoginViewProtocol, RegisteredUserDelegate {  
  
  func userWasCreated(_ user: TaskUser) {
    // doublecheck valid uid and then proceed to main view
    self.uid = user.uid
    performSegue(withIdentifier: "toMain", sender: nil)
  }
  
  func isUserLoggedIn() {
    Auth.auth().addStateDidChangeListener {[weak self] (auth, user) in
      if user != nil {
        self?.uid = user!.uid
        self?.performSegue(withIdentifier: "toMain", sender: nil)
      }
    }
  }
  
  
}

extension LoginViewController : UITextFieldDelegate {
  

}


