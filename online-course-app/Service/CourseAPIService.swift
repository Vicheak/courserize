//
//  CourseAPIService.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 18/8/24.
//

import UIKit
import Alamofire

class CourseAPIService {
    
    static let shared = CourseAPIService()
    
    func loadCourseByCategoryName(token: String, withCategoryName categoryName: String, completion: @escaping (Result<CourseResponse, ErrorResponse>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let apiEndpoint = Endpoint.loadCoursesWithCategory.rawValue + categoryName + "/courses"
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
                    let successResponse = try JSONDecoder().decode(CourseResponse.self, from: data)
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
    
    func loadCourseByUuid(token: String, uuid: String, completion: @escaping (Result<CourseResponseOne, ErrorResponseMessage>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let apiEndpoint = Endpoint.loadCourseByUuid.rawValue + uuid
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
                    let successResponse = try JSONDecoder().decode(CourseResponseOne.self, from: data)
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
    
    func loadCoursesByAuthenticatedAuthor(token: String, completion: @escaping (Result<CourseResponse, ErrorResponse>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        AF.request(Endpoint.loadCoursesByAuthenticatedAuthor.rawValue, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    let successResponse = try JSONDecoder().decode(CourseResponse.self, from: data)
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
    
    func searchCourses(token: String, searchCriteria search: String, completion: @escaping (Result<CourseResponse, ErrorResponse>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let apiEndpoint = Endpoint.searchCourses.rawValue + "_field=title&_direction=asc&title=" + search
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
                    let successResponse = try JSONDecoder().decode(CourseResponse.self, from: data)
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
    
    func createNewCourse(token: String, courseRequest: CourseRequest, completion: @escaping (Result<CourseResponseOne, Error>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["title": courseRequest.title, "description": courseRequest.description, "durationInHour": courseRequest.durationInHour, "cost": courseRequest.cost, "categoryId": courseRequest.categoryId] as [String : Any]
        AF.request(Endpoint.createNewCourse.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    } else if statusCode == 404 || statusCode == 409 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(CourseResponseOne.self, from: data)
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
    
    func updateCourseByUuid(token: String, courseRequest: CourseRequest, completion: @escaping (Result<CourseResponseOne, Error>) -> Void) {
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let params = ["title": courseRequest.title, "description": courseRequest.description, "durationInHour": courseRequest.durationInHour, "cost": courseRequest.cost, "categoryId": courseRequest.categoryId] as [String : Any]
        AF.request(Endpoint.updateCourseByUuid.rawValue, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).responseData { responseData in
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
                    } else if statusCode == 404 || statusCode == 409 {
                        let errorResponse = try JSONDecoder().decode(ErrorResponseMessage.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                        return
                    }
                    // Try to decode as a success response
                    let successResponse = try JSONDecoder().decode(CourseResponseOne.self, from: data)
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
    
    func deleteCourseByUuid(token: String, uuid: String, completion: @escaping (Result<MessageResponseData, ErrorResponseMessage>) -> Void){
        let bearerToken = token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json"
        ]
        let apiEndpoint = Endpoint.deleteCourseByUuid.rawValue + uuid
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
