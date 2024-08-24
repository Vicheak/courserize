//
//  VideoAPIService.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 21/8/24.
//

import UIKit
import Alamofire

class VideoAPIService {
    
    static let shared = VideoAPIService()
    
    func loadVideoByCourseUuid(token: String, withCourseUuid courseUuid: String, completion: @escaping (Result<VideoResponse, ErrorResponse>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let apiEndpoint = Endpoint.loadVideosByCourseUuid.rawValue + courseUuid + "/videos"
        AF.request(apiEndpoint, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    let successResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
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
    
    func loadVideoByUuid(token: String, uuid: String, completion: @escaping (Result<VideoResponseOne, ErrorResponseMessage>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let apiEndpoint = Endpoint.loadVideoByUuid.rawValue + uuid
        AF.request(apiEndpoint, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    let successResponse = try JSONDecoder().decode(VideoResponseOne.self, from: data)
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
    
    func createNewVideo(token: String, videoRequest: VideoRequest, completion: @escaping (Result<MessageResponseData, Error>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["title": videoRequest.title, "description": videoRequest.description, "videoLink": videoRequest.videoLink, "courseUuid": videoRequest.courseUuid]
        AF.request(Endpoint.createNewVideo.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    message: "Token is invalid or expired! Unauthorized",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            
            if statusCode == 201 {
                let successResponse = MessageResponseData(message: "A new video has been created successfully!")
                DispatchQueue.main.async {
                    completion(.success(successResponse))
                }
                return
            }
            
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    // Try to decode as an error response
                    if statusCode == 400 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    } else if statusCode == 404 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
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
    
    func updateVideoByUuid(token: String, videoRequest: VideoRequest, completion: @escaping (Result<MessageResponseData, Error>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["title": videoRequest.title, "description": videoRequest.description, "videoLink": videoRequest.videoLink, "courseUuid": videoRequest.courseUuid]
        AF.request(Endpoint.updateVideoByUuid.rawValue, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    message: "Token is invalid or expired! Unauthorized",
                    timestamp: Date(),
                    errors: []
                )
                DispatchQueue.main.async {
                    completion(.failure(unauthorizedError))
                }
                return
            }
            
            if statusCode == 200 {
                let successResponse = MessageResponseData(message: "A video has been updated successfully!")
                DispatchQueue.main.async {
                    completion(.success(successResponse))
                }
                return
            }
            
            switch responseData.result {
            case .success(let data):
                print("Success :", data)
                do {
                    // Try to decode as an error response
                    if statusCode == 404 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
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
    
    func deleteVideoByUuid(token: String, uuid: String, completion: @escaping (Result<MessageResponseData, ErrorResponseMessage>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let apiEndpoint = Endpoint.deleteVideoByUuid.rawValue + uuid
        AF.request(apiEndpoint, method: .delete, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
            
            if statusCode == 204 {
                let successResponse = MessageResponseData(message: "A video has been deleted successfully!")
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
                    if statusCode == 404 {
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
    
}
