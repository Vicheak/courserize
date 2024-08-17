//
//  AuthAPIService.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Alamofire
import KeychainSwift
import Localize_Swift

class AuthAPIService {
    
    static let shared = AuthAPIService()
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponseData, ErrorResponseData>) -> Void) {
        let params = ["email": email, "password": password]
        AF.request(Endpoint.login.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseData(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseData(
                    isSuccess: false,
                    code: statusCode,
                    message: "Incorrect email or password or you are unauthorized!",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(LoginResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    do {
                        // Try to decode as an error response
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                    } catch {
                        // If both decoding attempts fail, print the error and provide a generic error response
                        print("Decoding error : \(error.localizedDescription)")
                        let genericError = ErrorResponseData(
                            isSuccess: false,
                            code: statusCode,
                            message: "An unknown error occurred",
                            timestamp: Date(),
                            errors: []
                        )
                        DispatchQueue.main.async {
                            completion(.failure(genericError))
                        }
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseData(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func doRefreshToken(refreshToken: String, completion: @escaping (Result<LoginResponseData, ErrorResponseData>) -> Void) {
        let params = ["refreshToken": refreshToken]
        AF.request(Endpoint.refreshToken.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseData(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseData(
                    isSuccess: false,
                    code: statusCode,
                    message: "You are unauthorized!",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(LoginResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    do {
                        // Try to decode as an error response
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                    } catch {
                        // If both decoding attempts fail, print the error and provide a generic error response
                        print("Decoding error : \(error.localizedDescription)")
                        let genericError = ErrorResponseData(
                            isSuccess: false,
                            code: statusCode,
                            message: "An unknown error occurred",
                            timestamp: Date(),
                            errors: []
                        )
                        DispatchQueue.main.async {
                            completion(.failure(genericError))
                        }
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseData(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func register(username: String, email: String, phoneNumber: String, gender: String, birthDate: String, password: String, completion: @escaping (Result<MessageResponseData, Error>) -> Void) {
        let params = ["username": username, "email": email, "password": password, "gender": gender, "phoneNumber": phoneNumber, "dateOfBirth": birthDate]
        AF.request(Endpoint.register.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseData(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseData(
                    isSuccess: false,
                    code: statusCode,
                    message: "Unauthorized access",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    if statusCode == 409 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    } else if statusCode == 400 {
                        // Try to decode as an error response
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(MessageResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    // print the error and provide a generic error response
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseData(
                        isSuccess: false,
                        code: statusCode,
                        message: "An unknown error occurred",
                        timestamp: Date(),
                        errors: []
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseData(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func verifyCode(email: String, verifiedCode: String, completion: @escaping (Result<MessageResponseData, Error>) -> Void) {
        let params = ["email": email, "verifiedCode": verifiedCode]
        AF.request(Endpoint.verifyCode.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseData(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    if statusCode == 401 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    } else if statusCode == 400 {
                        // Try to decode as an error response
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(MessageResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    // print the error and provide a generic error response
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseData(
                        isSuccess: false,
                        code: statusCode,
                        message: "An unknown error occurred",
                        timestamp: Date(),
                        errors: []
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseData(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }

    func resendCode(email: String, completion: @escaping (Result<MessageResponseData, ErrorResponseData>) -> Void) {
        let params = ["email": email]
        AF.request(Endpoint.resendCode.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseData(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseData(
                    isSuccess: false,
                    code: statusCode,
                    message: "Unauthorized access",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    if statusCode == 400 {
                        // Try to decode as an error response
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(MessageResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    // print the error and provide a generic error response
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseData(
                        isSuccess: false,
                        code: statusCode,
                        message: "An unknown error occurred",
                        timestamp: Date(),
                        errors: []
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseData(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func forgetPassword(email: String, completion: @escaping (Result<ForgetPasswordResponseData, Error>) -> Void) {
        let params = ["email": email]
        AF.request(Endpoint.forgetPassword.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseData(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseData(
                    isSuccess: false,
                    code: statusCode,
                    message: "Unauthorized access",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    if statusCode == 404 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    } else if statusCode == 400 {
                        // Try to decode as an error response
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(ForgetPasswordResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    // print the error and provide a generic error response
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseData(
                        isSuccess: false,
                        code: statusCode,
                        message: "An unknown error occurred",
                        timestamp: Date(),
                        errors: []
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseData(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func resetPassword(email: String, token: String, password: String, completion: @escaping (Result<MessageResponseData, Error>) -> Void) {
        let params = ["email": email, "token": token, "password": password, "passwordConfirmation": password]
        AF.request(Endpoint.resetPassword.rawValue, method: .put, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseData(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    if statusCode == 401 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    } else if statusCode == 400 {
                        // Try to decode as an error response
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(MessageResponseData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    // print the error and provide a generic error response
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseData(
                        isSuccess: false,
                        code: statusCode,
                        message: "An unknown error occurred",
                        timestamp: Date(),
                        errors: []
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseData(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    public func shouldRefreshToken(completion: @escaping (Bool) -> Void) {
        let keychain = KeychainSwift()
        let refreshToken = keychain.get("refreshToken")!
        doRefreshToken(refreshToken: refreshToken) { response in
            switch response {
            case .success(let result):
                let keychain = KeychainSwift()
                keychain.set(result.accessToken, forKey: "accessToken")
                keychain.set(result.refreshToken, forKey: "refreshToken")
                completion(true)
            case .failure(let error):
                print("Response failure :", error)
                if error.code == 400 {
                    PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: error.errors[0].message, withAlert: .warning) {}
                } else if error.code == 401 {
                    PopUpUtil.popUp(withTitle: "Invalid".localized(using: "Generals"), withMessage: error.message, withAlert: .cross) {}
                } else {
                    PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: error.message, withAlert: .warning) {}
                }
                completion(false)
            }
        }
    }
    
}
