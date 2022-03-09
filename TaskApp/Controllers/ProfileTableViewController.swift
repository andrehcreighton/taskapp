//
//  ProfileTableViewController.swift
//  TaskApp
//
//  Created by Andre Creighton on 3/25/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var fullNameTF: UITextField!
  
  
  @IBOutlet weak var editPhotoButton: UIButton! {
    didSet{
      editPhotoButton.addTarget(self, action: #selector(editPhotoButtonTapped(_:)), for: .touchUpInside)
    }
  }
  @IBOutlet weak var saveButton: UIButton! {
    didSet{
      saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
    }
  }
  
  static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> ProfileTableViewController {
    let controller = storyboard.instantiateViewController(withIdentifier: "ProfileTableViewController") as! ProfileTableViewController
    return controller
  }
  
  private func navigationBarSetup(){
    navigationItem.title = "Profile"
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarSetup()
  }
  
  
  @IBAction func backButtonTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  @objc func saveButtonTapped(_ sender: Any){
    guard let fullname = fullNameTF.text else {
      print("Can't get fullname")
      return
    }
    
    print(fullname)
    
  }
  
  /* --Requires user to allow access to phone camera and library.
   --Selects or takes an image and compresses to a smaller size if needed.
   */
  @objc func editPhotoButtonTapped(_ sender: Any){
    
    print("Button is being tapped. Start Camera Roll / Take Photo Option")
    
    let controller = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)
    
    let photo = UIAlertAction(title: "Take Photo", style: .default) { _ in
      self.useCamera()
    }
    
    let library = UIAlertAction(title: "Select from Library", style: .default) { _ in
      self.usePhotoLibrary()
    }
    
    controller.addAction(photo)
    controller.addAction(library)
    
    present(controller, animated: true, completion: nil)
  }
}

extension ProfileTableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch indexPath.section {
    case 2:
      print("update email")
    case 3:
      print("change password")
    default:
      print("nothing")
    }
    
  }
}



extension ProfileTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private func useCamera() {
    if UIImagePickerController.isSourceTypeAvailable(.camera){
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self;
      imagePickerController.sourceType = .camera
      self.present(imagePickerController, animated: true, completion: nil)
    }
    
  }
  
  private func usePhotoLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      imagePickerController.sourceType = .savedPhotosAlbum
      imagePickerController.allowsEditing = false
      present(imagePickerController, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      profileImage.image = image
      self.dismiss(animated: true, completion: nil)
  }
  
}

