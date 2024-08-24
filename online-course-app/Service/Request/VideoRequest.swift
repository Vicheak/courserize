//
//  VideoRequest.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 23/8/24.
//

import Foundation

struct VideoRequest: Codable {
    var title: String
    var description: String
    var videoLink: String
    var courseUuid: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case videoLink
        case courseUuid
    }
    
    init(title: String, description: String, videoLink: String, courseUuid: String) {
        self.title = title
        self.description = description
        self.videoLink = videoLink
        self.courseUuid = courseUuid
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.videoLink, forKey: .videoLink)
        try container.encode(self.courseUuid, forKey: .courseUuid)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        videoLink = try container.decode(String.self, forKey: .videoLink)
        courseUuid = try container.decode(String.self, forKey: .courseUuid)
    }
}
