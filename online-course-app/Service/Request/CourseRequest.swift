//
//  CourseRequest.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 21/8/24.
//

import Foundation

struct CourseRequest: Codable {
    var title: String
    var description: String
    var durationInHour: Int
    var cost: Double
    var categoryId: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case durationInHour
        case cost
        case categoryId
    }
    
    init(title: String, description: String, durationInHour: Int, cost: Double, categoryId: Int) {
        self.title = title
        self.description = description
        self.durationInHour = durationInHour
        self.cost = cost
        self.categoryId = categoryId
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.durationInHour, forKey: .durationInHour)
        try container.encode(self.cost, forKey: .cost)
        try container.encode(self.categoryId, forKey: .categoryId)
    }
}
