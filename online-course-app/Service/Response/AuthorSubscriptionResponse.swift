//
//  AuthorSubscriptionResponse.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 21/8/24.
//

import Foundation

class AuthorSubscriptionResponse: Codable {
    //case : 200 OK
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var payload: AuthorSubscriptionPayload
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case payload
    }
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, payload: AuthorSubscriptionPayload) {
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
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        let timestampValue = try container.decode(String.self, forKey: .timestamp)
        timestamp = DateUtil.dateTimeFormatter.date(from: timestampValue) ?? Date()
        payload = try container.decode(AuthorSubscriptionPayload.self, forKey: .payload)
    }
}

class AuthorSubscriptionPayload: Codable {
    var authorUuid: String
    var author: String
    var authorEmail: String
    var subscriptions: [SubscriberSubscriptionPayload]
    
    enum CodingKeys: String, CodingKey {
        case authorUuid
        case author
        case authorEmail
        case subscriptions
    }
    
    init(authorUuid: String, author: String, authorEmail: String, subscriptions: [SubscriberSubscriptionPayload]) {
        self.authorUuid = authorUuid
        self.author = author
        self.authorEmail = authorEmail
        self.subscriptions = subscriptions
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.authorUuid, forKey: .authorUuid)
        try container.encode(self.author, forKey: .author)
        try container.encode(self.authorEmail, forKey: .authorEmail)
        try container.encode(self.subscriptions, forKey: .subscriptions)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authorUuid = try container.decode(String.self, forKey: .authorUuid)
        self.author = try container.decode(String.self, forKey: .author)
        self.authorEmail = try container.decode(String.self, forKey: .authorEmail)
        self.subscriptions = try container.decode([SubscriberSubscriptionPayload].self, forKey: .subscriptions)
    }
}
