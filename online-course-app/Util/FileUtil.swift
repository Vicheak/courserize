//
//  FileUtil.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 10/8/24.
//

import UIKit
import SkeletonView

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
    
    static func setUpCourseImage(imageUri: String, withImageView imageView: UIImageView){
        //load image from document directory
        let fileURL = URL(string: imageUri)!
        if let courseImage = FileUtil.loadImageFromDocumentDirectory(fileName: fileURL.lastPathComponent) {
            UIView.transition(with: imageView, duration: 1.5, options: [.curveEaseInOut]) {
                imageView.image = courseImage
            } completion: { _ in }
        } else {
            FileAPIService.shared.downloadImageAndSave(fileURL: imageUri) { response in
                switch response {
                case .success(_):
                    setUpCourseImage(imageUri: imageUri, withImageView: imageView)
                case .failure(let error):
                    print("Error :", error)
                    if #available(iOS 13.0, *) {
                        //set up loading
                        imageView.isSkeletonable = true
                        imageView.showAnimatedGradientSkeleton()
                    }
                }
            }
        }
    }
    
}
