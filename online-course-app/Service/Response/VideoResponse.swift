//
//  VideoResponse.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 21/8/24.
//

import Foundation

struct VideoResponse: Codable {
    //case : 200 OK
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var payload: [VideoResponsePayload]
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case payload
    }
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, payload: [VideoResponsePayload]) {
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
        payload = try container.decode([VideoResponsePayload].self, forKey: .payload)
    }
}

struct VideoResponseOne: Codable {
    //case : 200 OK
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var payload: VideoResponsePayload
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case payload
    }
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, payload: VideoResponsePayload) {
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
        payload = try container.decode(VideoResponsePayload.self, forKey: .payload)
    }
}

struct VideoResponsePayload: Codable {
    var uuid: String
    var title: String
    var description: String
    var videoLink: String
    var imageUri: String?
    var course: String
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case description
        case videoLink
        case imageUri
        case course
        case createdAt
        case updatedAt
    }
    
    init(uuid: String, title: String, description: String, videoLink: String, imageUri: String? = nil, course: String, createdAt: Date, updatedAt: Date) {
        self.uuid = uuid
        self.title = title
        self.description = description
        self.videoLink = videoLink
        self.imageUri = imageUri
        self.course = course
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.videoLink, forKey: .videoLink)
        try container.encode(self.imageUri, forKey: .imageUri)
        try container.encode(self.course, forKey: .course)
        try container.encode(DateUtil.dateTimeFormatter.string(from: self.createdAt), forKey: .createdAt)
        try container.encode(DateUtil.dateTimeFormatter.string(from: self.updatedAt), forKey: .updatedAt)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        videoLink = try container.decode(String.self, forKey: .videoLink)
        imageUri = try? container.decode(String.self, forKey: .imageUri)
        course = try container.decode(String.self, forKey: .course)
        let createdAtValue = try container.decode(String.self, forKey: .createdAt)
        createdAt = DateUtil.dateFormatter.date(from: createdAtValue) ?? Date()
        let updatedAtValue = try container.decode(String.self, forKey: .updatedAt)
        updatedAt = DateUtil.dateFormatter.date(from: updatedAtValue) ?? Date()
    }
}
