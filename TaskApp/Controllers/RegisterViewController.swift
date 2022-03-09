//
//  RegisterViewController.swift
//  TaskApp
//
//  Created by Andre Creighton on 3/24/21.
//

import UIKit
import ProgressHUD
import Firebase
import FirebaseFirestoreSwift

protocol RegisteredUserDelegate {
  func userWasCreated(_ user: TaskUser)
}

final class RegisterViewController: UIViewController {
  
  let db = Firestore.firestore()
  var registeredUserDelegate: RegisteredUserDelegate!
  
  static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> RegisterViewController {
      let controller = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
      return controller
    }

  @IBOutlet weak var registerNewUserButton: UIButton! {
    didSet{
      registerNewUserButton.setTitle("Login", for: .normal)
      registerNewUserButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
    }
  }
  
  @IBOutlet weak var emailTF: UITextField!{
    didSet{
      emailTF.text = ""
      emailTF.delegate = self
      emailTF.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
    }
  }
  @IBOutlet weak var passwordTF: UITextField! {
    didSet{
      passwordTF.text = ""
      passwordTF.isSecureTextEntry = true
      passwordTF.delegate = self
      passwordTF.addTarget(self, action: #selector(handleEditing), for: .editingChanged)
    }
  }
  
  @objc
  private func registerUser(){
    actionProgressStart()
    let email = emailTF.text!, password = passwordTF.text!
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
      if let error = error, let authErrorCode = AuthErrorCode(rawValue: error._code){
        ProgressHUD.dismiss()
        self?.alert(authErrorCode.errorMessage)
      }else{
        guard let user = result?.user else { return }
        let taskUser = TaskUser(uid: user.uid,
                                email: user.email!,
                                name: "")
        do{
          try self?.db.collection("users").document(taskUser.uid).setData(from: taskUser)
          ProgressHUD.dismiss()
          self?.registeredUserDelegate.userWasCreated(taskUser)
          self?.dismiss(animated: true, completion: nil)
        }catch let error{
          print("Error writing to firestore: \(error)")
        }
      }
    }
  }
  
  private func alert(_ message: String){
    
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
      self.passwordTF.text = ""
      self.emailTF.text = ""
      self.emailTF.becomeFirstResponder()
    })
    alertController.addAction(ok)
    present(alertController, animated: true, completion: nil)
    
  }
  
  private func actionProgressStart() {

    ProgressHUD.animationType = .circleStrokeSpin
    ProgressHUD.colorProgress = .systemBlue
    ProgressHUD.show()

  }
  
  
  @objc
  private func handleEditing(){
    if let password = passwordTF.text, let email = emailTF.text {
      enableRegister(Utilities.isEmailValid(email) && Utilities.isPasswordValid(password) ? true : false)
      }
  }
  
  private func enableRegister(_ bool: Bool){
    registerNewUserButton.isEnabled = bool
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      enableRegister(false)
        // Do any additional setup after loading the view.
    }
  

}

extension RegisterViewController: UITextFieldDelegate {
  
}
