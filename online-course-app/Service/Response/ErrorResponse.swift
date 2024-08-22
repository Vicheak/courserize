//
//  ErrorResponse.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 10/8/24.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let code: Int?
    let message: String
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
        timestamp = DateUtil.dateTimeFormatter.date(from: timestampValue) ?? Date()
        errors = try container.decode(String.self, forKey: .errors)
    }
}

struct ErrorResponseAPI: Codable, Error {
    var isSuccess: Bool
    var code: Int
    var timestamp: Date
    var errors: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case timestamp
        case errors
    }
    
    init(isSuccess: Bool, code: Int, timestamp: Date, errors: String){
        self.isSuccess = isSuccess
        self.code = code
        self.timestamp = timestamp
        self.errors = errors
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
        code = try container.decode(Int.self, forKey: .code)
        let timestampValue = try container.decode(String.self, forKey: .timestamp)
        timestamp = DateUtil.dateTimeFormatter.date(from: timestampValue) ?? Date()
        errors = try container.decode(String.self, forKey: .errors)
    }
}
