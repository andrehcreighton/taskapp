//
//  TasksMainViewController.swift
//  TaskApp
//
//  Created by Andre Creighton on 3/24/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


final class TasksMainViewController: UIViewController {
  
  static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> TasksMainViewController {
      let controller = storyboard.instantiateViewController(withIdentifier: "TasksMainViewController") as! TasksMainViewController
      return controller
    }
  
  @IBOutlet weak var projectCollectionView: UICollectionView! {
    didSet {
    projectCollectionView.delegate = self
    projectCollectionView.dataSource = self
    projectCollectionView.register(ProjectCollectionViewCell.nib(), forCellWithReuseIdentifier: ProjectCollectionViewCell.reuseIdentifier)
    }
  }
  
  let flowLayout: UICollectionViewFlowLayout = {
      let layout = UICollectionViewFlowLayout()
      layout.minimumInteritemSpacing = 5
      layout.minimumLineSpacing = 5
      layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
      return layout
  }()
  
  private let db = Firestore.firestore()
  @IBOutlet weak var menuButton: UIButton! {
    didSet{
      menuButton.addTarget(self, action: #selector(menu), for: .touchUpInside)
    }
  }
  
  @IBOutlet weak var newTaskButton: UIButton!{
    didSet{
      newTaskButton.addTarget(self, action: #selector(createNewTask), for: .touchUpInside)
    }
  }
  
  private var listOfProjects = [Project]() {
    didSet{
      projectCollectionView.reloadData()
    }
  }
  
  var uid = String()
  var project = Project()
  var currentUser = TaskUser(uid: "", email: "", name: "")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarSetup()
    loadUserProjects()
    projectCollectionView.collectionViewLayout = flowLayout
    
    // Do any additional setup after loading the view.
  }
  
  private func navigationBarSetup(){
    navigationItem.title = "Projects"
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func loadUserProjects(){
    
    db.collection("users").document(uid).collection("projects").addSnapshotListener { (querySnap, error) in
        guard let documents = querySnap?.documents else {
          print("Error fetching documents ", error!.localizedDescription )
          return
        }
      
      print(documents)
      do {
        let projects = try documents.map { try $0.data(as: Project.self)! }
        self.listOfProjects = projects.sorted(){
          $0.dueDate > $1.dueDate
        }

      }catch{
        print(error.localizedDescription)
      }
    }
  }
  
  @objc
  private func menu(){
    
    let alert = UIAlertController(title: "Menu", message: "", preferredStyle: .actionSheet)
    let l = UIAlertAction(title: "Logout", style: .destructive) { (_) in
      self.logout()
    }
    let profile = UIAlertAction(title: "See Profile", style: .default) { (_) in
      self.performSegue(withIdentifier: "toProfile", sender: nil)
    }
    alert.addAction(l)
    alert.addAction(profile)
    present(alert, animated: true, completion: nil)
  }

  @objc
  private func createNewTask(){
    let ac = UIAlertController(title: "New Project Name:", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
          guard let projectName = ac.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
          if projectName != "" {
            let uid = String.randomString(of: 10)
            let timeStamp = Int(NSDate().timeIntervalSince1970)
            let project = Project(id: uid, title: projectName, dueDate: timeStamp, status: 0, task: [])
            do {
              print("uid ", self.uid)
            try self.db.collection("users").document(self.uid).collection("projects").document(uid).setData(from: project, merge: true) { (error) in
              if let e = error {
                print("Error : ", e.localizedDescription)
              }else{
                print("Successfully added.")
              }
            }
            }catch let e{
              print(e.localizedDescription)
            }
          }else{
            print("can't leave blank")
          }
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
  }
  
  @objc
  private func logout(){
    
    let alert = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let confirm = UIAlertAction(title: "Confirm", style: .destructive) { (_) in
      let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
        self.navigationController?.popToRootViewController(animated: true)
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }
    }
    
    alert.addAction(cancel)
    alert.addAction(confirm)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toProfile" {
      if let destinationVC = segue.destination as? ProjectViewController{
        print(self.project.title)
        destinationVC.project = project
      }
    }
  }
}

extension String{
  static func randomString(of length: Int) -> String{
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      var s = ""
      for _ in 0 ..< length {
          s.append(letters.randomElement()!)
      }
    return s
  }
}

extension TasksMainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    self.project = listOfProjects[indexPath.row]
   // performSegue(withIdentifier: "toProject", sender: nil)
    
    let projectVC = ProjectViewController.fromStoryboard()
    projectVC.project = self.project
    self.navigationController?.pushViewController(projectVC, animated: true)
    
  }
  
}


extension TasksMainViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = projectCollectionView.bounds.width
    let numberOfItemsPerRow: CGFloat = 1
    let spacing: CGFloat = flowLayout.minimumInteritemSpacing
    let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
    let itemDimension = floor(availableWidth/numberOfItemsPerRow)
    return CGSize(width: itemDimension, height: itemDimension / 5)
  }
  

}

extension TasksMainViewController : UICollectionViewDataSource {
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listOfProjects.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = projectCollectionView.dequeueReusableCell(withReuseIdentifier: ProjectCollectionViewCell.reuseIdentifier, for: indexPath) as! ProjectCollectionViewCell
    
    cell.configure(listOfProjects[indexPath.row])
  
    return cell
  }
  
}
