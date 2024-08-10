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
