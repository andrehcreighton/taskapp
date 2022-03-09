//
//  ProjectCollectionViewCell.swift
//  TaskApp
//
//  Created by Andre Creighton on 4/5/21.
//

import UIKit

class ProjectCollectionViewCell: UICollectionViewCell {
  
  

  @IBOutlet weak var projectDetailLbl: UILabel!
  {
    didSet{
      projectDetailLbl.textColor = .darkGray
    }
  }
  @IBOutlet weak var titleOfProjectLbl: UILabel! {
    didSet{
      titleOfProjectLbl.textColor = .systemBlue
    }
  }


  static func nib() -> UINib {
    return UINib(nibName: "ProjectCollectionViewCell", bundle: nil)
  }
  
  static var reuseIdentifier = "ProjectCollectionViewCell"
  
  func configure(_ project: Project){
    
    titleOfProjectLbl.text = project.title
    
    
  }
  

}
