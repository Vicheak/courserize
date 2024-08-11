//
//  FileUtil.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 10/8/24.
//

import UIKit

public class FileUtil {

    public static func deleteAllTmpFile() {
        let fileManager = FileManager.default
        let tmpURL = NSTemporaryDirectory()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(string: tmpURL)!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted file : \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error deleting files : \(error)")
        }
    }
  
    public static func deleteAllFileInDirectory(path: FileManager.SearchPathDirectory){
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: path, in: .userDomainMask)[0]
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted file : \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error deleting files : \(error)")
        }
    }
    
    
    static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
}
