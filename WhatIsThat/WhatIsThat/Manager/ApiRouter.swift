//
//  Router.swift
//  WhatIsThat
//
//  Created by 渡邊浩二 on 2016/10/30.
//  Copyright © 2016年 渡邊浩二. All rights reserved.
//

import Alamofire
import ObjectMapper

protocol router {
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
}

enum ApiRouter: URLRequestConvertible, router {
    
    case cloudVision([String: Any])
    
    var path: String {
        switch self {
        case .cloudVision(_):
            return "https://vision.googleapis.com/v1/images:annotate?key=\(Const.API.CloudVision.ApiKey)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .cloudVision(_):
            return .post
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = method.rawValue
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        switch self {
        case .cloudVision(let params):
            return try! Alamofire.JSONEncoding.default.encode(request, with: params)
        }
    }
}