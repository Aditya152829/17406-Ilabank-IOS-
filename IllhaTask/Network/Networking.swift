//
//  Networking.swift
//  IllhaTask
//
//  Created by A1502 on 24/08/21.
//

import Foundation
import UIKit


enum Result<Value: Decodable> {
    case success(Value)
    case failure(Bool)
}
typealias Handler = (Result<Data>) -> Void
enum NetworkError: Error {
    case nullData
}
public enum Method {
    
    case get
    case post
    case other(method: String)
}
enum NetworkingError: String, LocalizedError {
    case jsonError = "JSON error"
    case other
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}
extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
        
        case "GET":
            self = .get
        case "POST":
            self = .post
        default:
            self = .other(method: method)
        }
    }
}
extension Method: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:               return "GET"
        case .post:              return "POST"
        case .other(let method): return method.uppercased()
        }
    }
}

protocol Requestable {}
extension Requestable {
    internal func getRequest(url: String, callback: @escaping (_ json: NSDictionary?) -> ()) {
        do {
            try request(method: .get, url: url, params: nil) { (dict) in
                //callback(dict)
            }
        } catch {
            callback(nil)
        }
    }
    
    internal func request(method: Method, url: String, params: [NSString: Any]? = nil, callback: @escaping Handler) {
        
        guard let url = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url,  completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        callback(.success(data!))
                        
                    } else {
                        
                        callback(.failure(true))
                    }
                }
            }
        })
        task.resume()
    }
}

