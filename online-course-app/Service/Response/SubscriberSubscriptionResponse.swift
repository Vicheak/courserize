//
//  SubscriberSubscriptionResponse.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 21/8/24.
//

import Foundation

struct SubscriberSubscriptionResponse: Codable {
    //case : 200 OK
    var isSuccess: Bool
    var code: Int
    var message: String
    var timestamp: Date
    var payload: SubscriberSubscriptionPayload
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case timestamp
        case payload
    }
    
    init(isSuccess: Bool, code: Int, message: String, timestamp: Date, payload: SubscriberSubscriptionPayload) {
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
        payload = try container.decode(SubscriberSubscriptionPayload.self, forKey: .payload)
    }
}

struct SubscriberSubscriptionPayload: Codable {
    var subscriberUuid: String
    var subscriber: String
    var subscriberEmail: String
    var subscriptionDetails: [SubscriberSubscriptionDetail]
    
    enum CodingKeys: String, CodingKey {
        case subscriberUuid
        case subscriber
        case subscriberEmail
        case subscriptionDetails
    }
    
    init(subscriberUuid: String, subscriber: String, subscriberEmail: String, subscriptionDetails: [SubscriberSubscriptionDetail]) {
        self.subscriberUuid = subscriberUuid
        self.subscriber = subscriber
        self.subscriberEmail = subscriberEmail
        self.subscriptionDetails = subscriptionDetails
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.subscriberUuid, forKey: .subscriberUuid)
        try container.encode(self.subscriber, forKey: .subscriber)
        try container.encode(self.subscriberEmail, forKey: .subscriberEmail)
        try container.encode(self.subscriptionDetails, forKey: .subscriptionDetails)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subscriberUuid = try container.decode(String.self, forKey: .subscriberUuid)
        self.subscriber = try container.decode(String.self, forKey: .subscriber)
        self.subscriberEmail = try container.decode(String.self, forKey: .subscriberEmail)
        self.subscriptionDetails = try container.decode([SubscriberSubscriptionDetail].self, forKey: .subscriptionDetails)
    }
}

struct SubscriberSubscriptionDetail: Codable {
    var subscriptionDetailId: Int
    var courseUuid: String
    var courseTitle: String
    var coursePrice: Double
    var isApproved: Bool
    
    enum CodingKeys: String, CodingKey {
        case subscriptionDetailId
        case courseUuid
        case courseTitle
        case coursePrice
        case isApproved
    }
    
    init(subscriptionDetailId: Int, courseUuid: String, courseTitle: String, coursePrice: Double, isApproved: Bool) {
        self.subscriptionDetailId = subscriptionDetailId
        self.courseUuid = courseUuid
        self.courseTitle = courseTitle
        self.coursePrice = coursePrice
        self.isApproved = isApproved
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.subscriptionDetailId, forKey: .subscriptionDetailId)
        try container.encode(self.courseUuid, forKey: .courseUuid)
        try container.encode(self.courseTitle, forKey: .courseTitle)
        try container.encode(self.coursePrice, forKey: .coursePrice)
        try container.encode(self.isApproved, forKey: .isApproved)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subscriptionDetailId = try container.decode(Int.self, forKey: .subscriptionDetailId)
        self.courseUuid = try container.decode(String.self, forKey: .courseUuid)
        self.courseTitle = try container.decode(String.self, forKey: .courseTitle)
        self.coursePrice = try container.decode(Double.self, forKey: .coursePrice)
        self.isApproved = try container.decode(Bool.self, forKey: .isApproved)
    }
}
