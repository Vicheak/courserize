//
//  UserProfileResponse.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 10/8/24.
//

import Foundation

struct UserProfileResponse: Codable {
    //case : 200 OK
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var payload: UserProfilePayload
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case payload
    }
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, payload: UserProfilePayload) {
        self.isSuccess = isSuccess
        self.code = code
        self.message = message
        self.timestamp = timestamp
        self.payload = payload
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isSuccess, forKey: .isSuccess)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.message, forKey: .message)
        try container.encode(DateUtil.dateTimeFormatter.string(from: self.timestamp), forKey: .timestamp)
        try container.encode(self.payload, forKey: .payload)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        let timestampValue = try container.decode(String.self, forKey: .timestamp)
        timestamp = DateUtil.dateTimeFormatter.date(from: timestampValue) ?? Date()
        payload = try container.decode(UserProfilePayload.self, forKey: .payload)
    }
}

struct UserProfilePayload: Codable {
    var uuid: String
    var username: String
    var email: String
    var gender: String
    var phoneNumber: String
    var dateOfBirth: Date
    var joinDate: Date
    var photoUri: String?
    var isVerified: Bool
    var isEnabled: Bool
    var userRoles: [UserRole]
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case username
        case email
        case gender
        case phoneNumber
        case dateOfBirth
        case joinDate
        case photoUri
        case isVerified
        case isEnabled
        case userRoles
    }
    
    init(uuid: String, username: String, email: String, gender: String, phoneNumber: String, dateOfBirth: Date, joinDate: Date, photoUri: String, isVerified: Bool, isEnabled: Bool, userRoles: [UserRole]) {
        self.uuid = uuid
        self.username = username
        self.email = email
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
        self.joinDate = joinDate
        self.photoUri = photoUri
        self.isVerified = isVerified
        self.isEnabled = isEnabled
        self.userRoles = userRoles
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.gender, forKey: .gender)
        try container.encode(self.phoneNumber, forKey: .phoneNumber)
        try container.encode(DateUtil.dateFormatter.string(from: self.dateOfBirth), forKey: .dateOfBirth)
        try container.encode(DateUtil.dateTimeFormatter.string(from: self.joinDate), forKey: .joinDate)
        try? container.encode(self.photoUri, forKey: .photoUri)
        try container.encode(self.isVerified, forKey: .isVerified)
        try container.encode(self.isEnabled, forKey: .isEnabled)
        try container.encode(self.userRoles, forKey: .userRoles)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        gender = try container.decode(String.self, forKey: .gender)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        let dateOfBirthValue = try container.decode(String.self, forKey: .dateOfBirth)
        dateOfBirth = DateUtil.dateFormatter.date(from: dateOfBirthValue) ?? Date()
        let joinDateValue = try container.decode(String.self, forKey: .joinDate)
        joinDate = DateUtil.dateTimeFormatter.date(from: joinDateValue) ?? Date()
        photoUri = try? container.decode(String.self, forKey: .photoUri)
        isVerified = try container.decode(Bool.self, forKey: .isVerified)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        userRoles = try container.decode([UserRole].self, forKey: .userRoles)
    }
}

struct UserRole: Codable {
    var role: Role
    
    enum CodingKeys: String, CodingKey {
        case role
    }
    
    init(role: Role) {
        self.role = role
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decode(Role.self, forKey: .role)
    }
}

struct Role: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
}
