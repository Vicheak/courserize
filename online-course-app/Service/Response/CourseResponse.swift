//
//  CourseResponse.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 18/8/24.
//

import Foundation

struct CourseResponse: Codable {
    //case : 200 OK
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var payload: [CourseResponsePayload]
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case payload
    }
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, payload: [CourseResponsePayload]) {
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
        payload = try container.decode([CourseResponsePayload].self, forKey: .payload)
    }
}

struct CourseResponsePayload: Codable {
    var uuid: String
    var title: String
    var description: String
    var imageUri: String?
    var durationInHour: Int
    var cost: Double
    var numberOfView: Int
    var numberOfLike: Int
    var category: String
    var author: String
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case description
        case imageUri
        case durationInHour
        case cost
        case numberOfView
        case numberOfLike
        case category
        case author
        case createdAt
        case updatedAt
    }
    
    init(uuid: String, title: String, description: String, imageUri: String? = nil, durationInHour: Int, cost: Double, numberOfView: Int, numberOfLike: Int, category: String, author: String, createdAt: Date, updatedAt: Date) {
        self.uuid = uuid
        self.title = title
        self.description = description
        self.imageUri = imageUri
        self.durationInHour = durationInHour
        self.cost = cost
        self.numberOfView = numberOfView
        self.numberOfLike = numberOfLike
        self.category = category
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.imageUri, forKey: .imageUri)
        try container.encode(self.durationInHour, forKey: .durationInHour)
        try container.encode(self.cost, forKey: .cost)
        try? container.encode(self.numberOfView, forKey: .numberOfView)
        try container.encode(self.numberOfLike, forKey: .numberOfLike)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.author, forKey: .author)
        try container.encode(DateUtil.dateTimeFormatter.string(from: self.createdAt), forKey: .createdAt)
        try container.encode(DateUtil.dateTimeFormatter.string(from: self.updatedAt), forKey: .updatedAt)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        imageUri = try? container.decode(String.self, forKey: .imageUri)
        durationInHour = try container.decode(Int.self, forKey: .durationInHour)
        cost = try container.decode(Double.self, forKey: .cost)
        numberOfView = try container.decode(Int.self, forKey: .numberOfView)
        numberOfLike = try container.decode(Int.self, forKey: .numberOfLike)
        category = try container.decode(String.self, forKey: .category)
        author = try container.decode(String.self, forKey: .author)
        let createdAtValue = try container.decode(String.self, forKey: .createdAt)
        createdAt = DateUtil.dateFormatter.date(from: createdAtValue) ?? Date()
        let updatedAtValue = try container.decode(String.self, forKey: .updatedAt)
        updatedAt = DateUtil.dateFormatter.date(from: updatedAtValue) ?? Date()
    }
    
}
