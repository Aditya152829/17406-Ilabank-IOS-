//
//  PostViewModel.swift
//  IllhaTask
//
//  Created by A1502 on 24/08/21.
//


import Foundation
import UIKit

//MARK: - Protocol Defining here
protocol PostViewModelProtocol {
    var postDidChanges: ((Bool, Bool) -> Void)? { get set }
    func fetchpostListData()
}
class PostViewModel: PostViewModelProtocol {
    //MARK: - Internal Properties
    var postDidChanges: ((Bool, Bool) -> Void)?
    var requestPostData: [PostModel]? {
        didSet {
            self.postDidChanges!(true, false)
        }
    }
    var requestPostDataSearch: [PostModel]?
    func fetchpostListData() {
        PostAPIService.instance.fetchPostList { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! NSArray
                    let arrMenu = json
                    var arrDashboard = [PostModel]()
                    for obj in arrMenu {
                        let objDashboard = PostModel(dictInfo: obj as! [String : Any])
                        arrDashboard.append(objDashboard)
                    }
                    self.requestPostData = arrDashboard
                    self.requestPostDataSearch = arrDashboard
                    
                } catch {
                    print("JSON Serialization error")
                }
                break
            case .failure(let error):
                
                print(error.description)
            }
        }
    }
}


