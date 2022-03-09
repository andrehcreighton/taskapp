//
//  ProjectViewController.swift
//  TaskApp
//
//  Created by Andre Creighton on 6/10/21.
//

import UIKit

class ProjectViewController: UIViewController {
 
  static func fromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> ProjectViewController {
      let controller = storyboard.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
      return controller
    }
  
  var project = Project()
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      navigationBarSetup()
    }
    
  private func navigationBarSetup(){
    print(project.title)
    navigationItem.title = project.title
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  @IBAction func backButtonPressed(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
