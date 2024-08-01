//
//  Endpoint.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import Foundation

enum Endpoint: String {
    
    static let endpoint = "https://api.cheakautomate.online/api/v1/"
    
    case login
    case register
    case verifyCode
    
    var rawValue: String {
        switch self {
        case .login:
            return Endpoint.endpoint + "auth/login"
        case .register:
            return Endpoint.endpoint + "auth/register"
        case .verifyCode:
            return Endpoint.endpoint + "auth/verify"
        }
    }
    
}
