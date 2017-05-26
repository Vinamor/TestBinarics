//
//  NetworkManager.swift
//  My Money Flow
//
//  Created by Mac on 4/21/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import Alamofire


class LivingWordsAPI {
    
    // singelton
    static let instance = LivingWordsAPI()
    init(){}
    
    var service: ServiceProtocol = AlamofireService()
}

extension LivingWordsAPI {
    fileprivate enum Router: URLRequestConvertible {
    
        
        // User authorization
        case loginWithEmail(parameters: Parameters)
        
        case confirmEmail(parameters: Parameters)
        
        case checkThePassCode(parameters: Parameters)
        
        case confirmNewPassword(parameters: Parameters)
        
        case signUpWithEmail(parameters: Parameters)
        
        case loginFacebook(parameters: Parameters)
        
        case loginGoogle(parameters: Parameters)
        
        private var baseURLString: String {
            return ""
        }
        
        func addHeadersForRequest( request: inout URLRequest) {
            request.setValue("", forHTTPHeaderField: "Access-token")
            // request.setValue(String(id), forHTTPHeaderField: "user-id")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        //MARK: URLRequestConvertible
        func asURLRequest() throws -> URLRequest {
            let url = try baseURLString.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            //addHeadersForRequest(request: &urlRequest)
            urlRequest = try addParametersForRequest(request: urlRequest)
            
            return urlRequest
        }
        
        private var path: String {
            switch self {
            case .loginWithEmail:
                return ""
                
            case .confirmEmail:
                return ""
                
            case .checkThePassCode:
                return ""
                
            case .confirmNewPassword:
                return ""
                
            case .signUpWithEmail:
                return ""
                
            case .loginFacebook:
                return ""
                
            case .loginGoogle:
                return ""
                
            }
            
        }
        
        private var method: HTTPMethod {
            switch self {
                
        //  case :
             // return .get
                
            case .loginWithEmail, .confirmEmail, .checkThePassCode,
                 .confirmNewPassword, .signUpWithEmail,
                 .loginFacebook, .loginGoogle:
                
                return .post
                
            }
        }
        
        private var token: String {
            switch self {
            case  .confirmEmail, .checkThePassCode, .confirmNewPassword,
                  .loginWithEmail, .signUpWithEmail,
                  .loginFacebook, .loginGoogle:
                
                return ""
            }
        }
        
        private var id: Int {
            switch self {
            case .confirmEmail, .checkThePassCode, .confirmNewPassword,
                 .loginWithEmail, .signUpWithEmail,
                 .loginFacebook, .loginGoogle:
                
                return 0
            }
        }
        
        private func addParametersForRequest(request: URLRequest) throws -> URLRequest {
            var request = request
            switch self {
            case .loginWithEmail(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .confirmEmail(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .checkThePassCode(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .confirmNewPassword(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .signUpWithEmail(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .loginFacebook(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
                
            case .loginGoogle(let parameters):
                request = try JSONEncoding.default.encode(request, with: parameters)
            }
                return request
        }
    }
}

extension LivingWordsAPI {
    
    @discardableResult
    func login(withEmail email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> DataRequest  {
        let request = Router.loginWithEmail(parameters: ["email"     : email,
                                                         "password"  : password])
        
        return service.request(request: request).responseObject(completionHandler: { (response: DataResponse<User>) in
            completion(response.result.value, response.result.error)
        })
    }
    
    @discardableResult
    func signUpWithEmail( email: String, password: String, phone: String, contentType: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> DataRequest  {
        let request = Router.signUpWithEmail(parameters: ["email"   : email,
                                                         "password" : password,
                                                         "phone"    : phone,
                                                         ])
        
        return service.request(request: request).responseObject(completionHandler: { (response: DataResponse<User>) in
            completion(response.result.value, response.result.error)
        })
    }
    
    @discardableResult
    func loginFacebook(token: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> DataRequest {
        let request = Router.loginFacebook(parameters: ["token" : token,
                                                         "type" : 1 ])
        
        return service.request(request: request).responseObject(completionHandler: { (response: DataResponse<User>) in
            completion(response.result.value, response.result.error)
        })
    }
    
    @discardableResult
    func loginGoogle(id: String, email: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> DataRequest {
        let request = Router.loginGoogle(parameters: ["id" : id,
                                                    "type" : 2,
                                                   "email" : email ])
        
        return service.request(request: request).responseObject(completionHandler: { (response: DataResponse<User>) in
            completion(response.result.value, response.result.error)
        })
    }
}

extension LivingWordsAPI {
    
    @discardableResult
    func confirmEmail(email: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> DataRequest {
        
        let request = Router.confirmEmail(parameters: ["email" : email])
        
        return service.request(request: request).responseObject(completionHandler: { (response: DataResponse<User>) in
            completion(response.result.value, response.result.error)
        })
    }
    
    @discardableResult
    func checkThePassCode(code: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> DataRequest {
        
        let request = Router.checkThePassCode(parameters: ["code" : code])
        
        return service.request(request: request).responseObject(completionHandler: { (response: DataResponse<User>) in
            completion(response.result.value, response.result.error)
            
        })
    }
    
    @discardableResult
    func confirmNewPassword(user_id: Int, newPassword: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) -> DataRequest {
        let request = Router.confirmNewPassword(parameters: ["user_id" : user_id,
                                                         "new_password": newPassword])
        
        
        return service.request(request: request).responseObject(completionHandler: { (response: DataResponse<User>) in
            completion(response.result.value, response.result.error)
            
        })
    }
    
}
