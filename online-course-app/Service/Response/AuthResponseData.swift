//
//  ResponseData.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit

struct LoginResponseData: Codable {
    //case : 201 Created
    var accessToken: String
    var refreshToken: String
    var type: String
}

struct ErrorResponseData: Codable, Error {
    //case : 400 Bad Request
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var errors: [FieldError]
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case errors
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, errors: [FieldError]){
        self.isSuccess = isSuccess
        self.code = code
        self.message = message
        self.timestamp = timestamp
        self.errors = errors
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        let timestampValue = try container.decode(String.self, forKey: .timestamp)
        timestamp = ErrorResponseData.dateFormatter.date(from: timestampValue) ?? Date()
        errors = try container.decode([FieldError].self, forKey: .errors)
    }
}

struct FieldError: Codable {
    var fieldName: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case fieldName
        case message
    }
    
    init(fieldName: String, message: String){
        self.fieldName = fieldName
        self.message = message
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fieldName = try container.decode(String.self, forKey: .fieldName)
        message = try container.decode(String.self, forKey: .message)
    }
}

struct MessageResponseData: Codable {
    //case : 201 Created
    var message: String
}

struct ErrorResponseMessage: Codable, Error {
    //case : 409 Conflict
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var errors: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case errors
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, errors: String){
        self.isSuccess = isSuccess
        self.code = code
        self.message = message
        self.timestamp = timestamp
        self.errors = errors
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        let timestampValue = try container.decode(String.self, forKey: .timestamp)
        timestamp = ErrorResponseData.dateFormatter.date(from: timestampValue) ?? Date()
        errors = try container.decode(String.self, forKey: .errors)
    }
}
