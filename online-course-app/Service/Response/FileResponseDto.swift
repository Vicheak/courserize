//
//  FileResponseDto.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 11/8/24.
//

import UIKit

struct FileResponse: Decodable {
    //case : 200 OK
    var fileName: String
    var uri: String
    var downloadUri: String
    var size: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case uri
        case downloadUri
        case size
    }
    
    init(fileName: String, uri: String, downloadUri: String, size: Double) {
        self.fileName = fileName
        self.uri = uri
        self.downloadUri = downloadUri
        self.size = size
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fileName = try container.decode(String.self, forKey: .name)
        uri = try container.decode(String.self, forKey: .uri)
        downloadUri = try container.decode(String.self, forKey: .downloadUri)
        size = try container.decode(Double.self, forKey: .size)
    }
}
