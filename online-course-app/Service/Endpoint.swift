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
    case resendCode
    case forgetPassword
    case resetPassword
    
    var rawValue: String {
        switch self {
        case .login:
            return Endpoint.endpoint + "auth/login"
        case .register:
            return Endpoint.endpoint + "auth/register"
        case .verifyCode:
            return Endpoint.endpoint + "auth/verify"
        case .resendCode:
            return Endpoint.endpoint + "auth/send-verification-code"
        case .forgetPassword:
            return Endpoint.endpoint + "auth/forget-password"
        case .resetPassword:
            return Endpoint.endpoint + "auth/reset-password"
        }
    }
    
}
