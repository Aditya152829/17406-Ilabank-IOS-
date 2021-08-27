//
//  PostAPIService.swift
//  IllhaTask
//
//  Created by A1502 on 24/08/21.
//

import Foundation

class PostAPIService: NSObject, Requestable {
    
    static let instance = PostAPIService()
    
    func fetchPostList(callback: @escaping Handler) {
        request(method: .get, url: Domain.baseUrl() + APIEndpoint.postGet) { (result) in
            callback(result)
        }
        
    }
    
}
