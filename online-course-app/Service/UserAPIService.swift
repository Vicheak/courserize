//
//  UserAPIService.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 10/8/24.
//

import UIKit
import Alamofire

class UserAPIService {
    
    static let shared = UserAPIService()
    
    func userProfile(token: String, completion: @escaping (Result<UserProfileResponse, ErrorResponse>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        AF.request(Endpoint.userProfile.rawValue, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                let error = ErrorResponse(code: (responseData.error! as NSError).code, message: "The Internet connection appears to be offline.")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if statusCode == 401 {
                let unauthorizedError = ErrorResponse(code: statusCode, message: "Token is invalid or expired! Unauthorized")
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
                    let successResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(successResponse))
                    }
                } catch {
                    let errorResponse = ErrorResponse(code: statusCode, message: "Failed to decode response from server")
                    DispatchQueue.main.async {
                        completion(.failure(errorResponse))
                    }
                }
            case .failure(let error):
                print("Error :", error)
                let networkError = ErrorResponse(code: (error as NSError).code, message: "Cannot get response from server")
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        return
    }
    
    func uploadUserPhotoByUuid(token: String, uuid: String, fileURL: URL, completion: @escaping (Result<FileResponse, ErrorResponseMessage>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)"
        ]
        let backendUrl = Endpoint.uploadUserPhotoByUuid.rawValue + uuid
        let request = AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "file")
            }, to: backendUrl, method: .put, headers: headers)
        request.validate().responseDecodable(of: FileResponse.self, completionHandler: { response in
            switch response.result {
            case .success(let result):
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            case .failure(let error):
                print("Error :", error)
                let error = ErrorResponseMessage(
                    isSuccess: false,
                    code: (error as NSError).code,
                    message: "An error occurs",
                    timestamp: Date(),
                    errors: "Request entity too large!"
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
        return
    }
    
    func updateUserProfileByUuid(token: String, username: String, phoneNumber: String, uuid: String, completion: @escaping (Result<MessageResponseData, ErrorResponseMessage>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["username": username, "phoneNumber": phoneNumber]
        let backendUrl = Endpoint.updateUserProfileByUuid.rawValue + uuid
        AF.request(backendUrl, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    message: "Unauthorized access",
                    timestamp: Date(),
                    errors: "An error occurs"
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            } else if statusCode == 200 {
                let successResponse = MessageResponseData(message: "User profile updated successfully!")
                DispatchQueue.main.async {
                    completion(.success(successResponse))
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
    
    func changePassword(token: String, uuid: String, oldPassword: String, password: String, completion: @escaping (Result<MessageResponseData, ErrorResponseMessage>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["oldPassword": oldPassword, "password": password, "passwordConfirmation": password]
        let backendUrl = Endpoint.changePassword.rawValue + uuid
        AF.request(backendUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    message: "Unauthorized access or incorrect password",
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
                    let successResponse = try JSONDecoder().decode(MessageResponseData.self, from: data)
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
