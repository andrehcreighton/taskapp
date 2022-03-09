//
//  Project.swift
//  TaskApp
//
//  Created by Andre Creighton on 3/24/21.
//

import Foundation

struct Project : Codable {
  
  var id: String
  var title: String
  var dueDate: Int
  var status: Int
  var task: [Task]
  
  init(id: String, title: String, dueDate: Int, status: Int, task: [Task]) {
    self.id = id
    self.title = title
    self.dueDate = dueDate
    self.status = status
    self.task = task
  }

  init() {
    self.id = ""
    self.title = ""
    self.dueDate = 0
    self.status = 0
    self.task = []
  }

  func data() -> [String:Any]{
    
    return ["id":id,
            "title":title,
            "dueDate": dueDate,
            "status": status]
    
  }
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case title
    case dueDate
    case status
    case task
    
    
  }
}

struct Task : Codable {
  
  var id: String
  var detail: String
  var status: Int
  
  
  func data() -> [String : Any] {
    
    return ["id": id,"detail": detail, "status":status]
    
  }
  
  enum CodingKeys: String, CodingKey {
    
    case id
    case detail
    case status
    
  }
 
}
