//
//  AlamofireService.swift
//  BibleApp
//
//  Created by Igor Makara on 4/21/17.
//  Copyright © 2017 Igor Makara. All rights reserved.
//

import Alamofire

protocol ServiceProtocol {
    func request(request: URLRequestConvertible) -> DataRequest
}

class AlamofireService: ServiceProtocol {
    func request(request: URLRequestConvertible) -> DataRequest {
        return Alamofire.request(request)
    }
}
