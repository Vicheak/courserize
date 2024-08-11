//
//  FileAPIService.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 11/8/24.
//

import UIKit
import Alamofire

class FileAPIService {
    
    static let shared = FileAPIService()
    
    func downloadImageAndSave(fileURL: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: fileURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // Download the image
        AF.download(url).responseData { response in
            switch response.result {
            case .success(let data):
                // Save the image to the document directory
                do {
                    let fileManager = FileManager.default
                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileName = url.lastPathComponent
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)

                    // Save data to file
                    try data.write(to: fileURL)
                    completion(.success(fileURL))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
