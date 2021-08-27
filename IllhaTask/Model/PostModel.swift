//
//  PostModel.swift
//  IllhaTask
//
//  Created by A1502 on 24/08/21.
//

import Foundation
import UIKit

class PostModel: NSObject {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
    init(dictInfo:[String:Any]) {
        userId = dictInfo["userId"] as? Int
        id = dictInfo["id"] as? Int
        title = dictInfo["title"] as? String
        body = dictInfo["body"] as? String
        
    }
    
}
