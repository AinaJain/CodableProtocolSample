//
//  DownloadManager.swift
//  CodableSample
//
//  Created by Aina Jain on 11/03/19.
//  Copyright © 2019 Aina Jain. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {

    class func downloadData(withUrl url : URL,completionHandler :@escaping (([TableModel]?,Bool)->())) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{
                return
            }
            do {
                if (try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any]) != nil {
                    var modelArray = [TableModel]()
                    let infoModelObj = try JSONDecoder().decode(InfoModel.self, from: data)
                    for item in infoModelObj.items {
                        let title = item.snippet.title
                        let url = URL(string: item.snippet.thumbnails.medium.url)
                        let youTubeId = item.id.videoId
                        var imgPath = ""
                        if let docDicrectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                            imgPath = "\(docDicrectoryPath)/\(youTubeId)"
                        }
                        
                        let modelObj = TableModel(title: title, url: url!, youTubeId: youTubeId, imagePath: imgPath)
                        DatabaseManager.shared.addRecordToTableInfo(withRecord: modelObj)
                        modelArray.append(modelObj)
                    }
                    completionHandler(modelArray,true)
                }
            } catch {
                completionHandler(nil,false)
                print("Unable to parse data")
            }
            }.resume()
    }
    
    
    class func writeImage(withName name : String?,_ image : UIImage?) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent("\(name ?? "\(Date())").jpeg" )
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = image?.jpegData(compressionQuality: 1.0) {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("file saved")
                } catch {
                    print("error saving file:", error)
                }
            }
        }
    }
    
    class func getImage(forFile fileName : String?) -> UIImage? {
        
        if let nsDocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let fileName = fileName {
            let imageURL = nsDocumentDirectory.appendingPathComponent(fileName)
            if let image    = UIImage(contentsOfFile: imageURL.path) {
                return image
            }
        }
        return nil
    }
}
