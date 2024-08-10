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
    
}
