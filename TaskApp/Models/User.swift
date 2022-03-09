//
//  User.swift
//  TaskApp
//
//  Created by Andre Creighton on 3/24/21.
//

import Foundation

protocol RequiredUser {
  var uid: String { get }
  var email: String { get }
  var name: String { get }
}

struct TaskUser: RequiredUser, Codable {
  
  let uid: String
  let email: String
  let name: String
  
  
  enum CodingKeys: String, CodingKey {
    case uid
    case email
    case name
    
  }
  
}

extension TaskUser {
  
  init(){
    self.init(uid: "", email: "", name: "")
  }
  
}



