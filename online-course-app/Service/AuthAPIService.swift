//
//  AuthAPIService.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Alamofire

class AuthAPIService {
    
    static let shared = AuthAPIService()
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponseData, ErrorResponseData>) -> Void) {
        let params = ["email": email, "password": password]
        AF.request(Endpoint.login.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            let statusCode = responseData.response!.statusCode
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
    
    func register(username: String, email: String, phoneNumber: String, gender: String, birthDate: String, password: String, completion: @escaping (Result<MessageResponseData, Error>) -> Void) {
        let params = ["username": username, "email": email, "password": password, "gender": gender, "phoneNumber": phoneNumber, "dateOfBirth": birthDate]
        AF.request(Endpoint.register.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default).responseData { responseData in
            let statusCode = responseData.response!.statusCode
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
            let statusCode = responseData.response!.statusCode
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
    
}
