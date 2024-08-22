//
//  SubscriptionAPIService.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 21/8/24.
//

import UIKit
import Alamofire

class SubscriptionAPIService {
    
    static let shared = SubscriptionAPIService()
    
    func enroll(token: String, authorUuid: String, courseUuid: String, completion: @escaping (Result<MessageResponseData, ErrorResponseMessage>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["authorUuid": authorUuid, "courseUuids": [courseUuid]] as [String : Any]
        AF.request(Endpoint.enroll.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseMessage(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: "An error occurs"
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseMessage(
                    isSuccess: false,
                    code: statusCode,
                    message: "Token is invalid or expired! Unauthorized",
                    timestamp: Date(),
                    errors: "An error occurs"
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            
            if statusCode == 201 {
                let successResponse = MessageResponseData(message: "Subscription has been completed and has been sent to the author!")
                DispatchQueue.main.async {
                    completion(.success(successResponse))
                }
                return
            }
            
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    // Try to decode as a success response
                    if statusCode == 400 || statusCode == 404 || statusCode == 409 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                } catch {
                    // print the error and provide a generic error response
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseMessage(
                        isSuccess: false,
                        code: statusCode,
                        message: "An unknown error occurred",
                        timestamp: Date(),
                        errors: "An error occurs"
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseMessage(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: "An error occurs"
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func loadSubscriptionByAuthenticatedSubscriber(token: String, completion: @escaping (Result<SubscriberSubscriptionResponse, ErrorResponseAPI>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        AF.request(Endpoint.loadSubscriptionByAuthenticatedSubscriber.rawValue, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseAPI(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    timestamp: Date(),
                    errors: "The Internet connection appears to be offline."
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseAPI(
                    isSuccess: false,
                    code: statusCode,
                    timestamp: Date(),
                    errors: "Token is invalid or expired! Unauthorized"
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
                    if statusCode == 404 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseAPI.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    let successResponse = try JSONDecoder().decode(SubscriberSubscriptionResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseAPI(
                        isSuccess: false,
                        code: statusCode,
                        timestamp: Date(),
                        errors: "An error occurs"
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseAPI(
                    isSuccess: false,
                    code: (error as NSError).code,
                    timestamp: Date(),
                    errors: "Cannot get response from server"
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func loadSubscriptionByAuthenticatedAuthor(token: String, completion: @escaping (Result<AuthorSubscriptionResponse, ErrorResponseAPI>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        AF.request(Endpoint.loadSubscriptionByAuthenticatedAuthor.rawValue, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseAPI(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    timestamp: Date(),
                    errors: "The Internet connection appears to be offline."
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseAPI(
                    isSuccess: false,
                    code: statusCode,
                    timestamp: Date(),
                    errors: "Token is invalid or expired! Unauthorized"
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            } else if statusCode == 403 {
                let unauthorizedError = ErrorResponseAPI(
                    isSuccess: false,
                    code: statusCode,
                    timestamp: Date(),
                    errors: "You must be an author to authorize, please register for an author first!"
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
                    if statusCode == 404 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseAPI.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    let successResponse = try JSONDecoder().decode(AuthorSubscriptionResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseAPI(
                        isSuccess: false,
                        code: statusCode,
                        timestamp: Date(),
                        errors: "An error occurs"
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseAPI(
                    isSuccess: false,
                    code: (error as NSError).code,
                    timestamp: Date(),
                    errors: "Cannot get response from server"
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func approveOrRejectSubscription(token: String, subscriptionDetailId: Int, courseUuid: String, approve: Bool, completion: @escaping (Result<MessageResponseData, ErrorResponseMessage>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["subscriptionDetailId": subscriptionDetailId, "courseUuid": courseUuid, "approve": approve] as [String : Any]
        AF.request(Endpoint.approveOrRejectSubscription.rawValue, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponseMessage(
                    isSuccess: false,
                    code: (responseData.error! as NSError).code,
                    message: "The Internet connection appears to be offline.",
                    timestamp: Date(),
                    errors: "An error occurs"
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponseMessage(
                    isSuccess: false,
                    code: statusCode,
                    message: "Token is invalid or expired! Unauthorized",
                    timestamp: Date(),
                    errors: "An error occurs"
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            } else if statusCode == 403 {
                let unauthorizedError = ErrorResponseMessage(
                    isSuccess: false,
                    code: statusCode,
                    message: "You must be an author to authorize, please register for an author first!",
                    timestamp: Date(),
                    errors: "An error occurs"
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
                    if statusCode == 404 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    let successResponse = MessageResponseData(message: "Action completed!")
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    // print the error and provide a generic error response
                    print("Decoding error : \(error.localizedDescription)")
                    let genericError = ErrorResponseMessage(
                        isSuccess: false,
                        code: statusCode,
                        message: "An unknown error occurred",
                        timestamp: Date(),
                        errors: "An error occurs"
                    )
                    DispatchQueue.main.async {
                        completion(.failure(genericError))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponseMessage(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "Cannot get response from server",
                    timestamp: Date(),
                    errors: "An error occurs"
                )
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
}
