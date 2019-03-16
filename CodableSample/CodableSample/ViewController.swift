//
//  ViewController.swift
//  CodableSample
//
//  Created by Aina Jain on 10/03/19.
//  Copyright © 2019 Aina Jain. All rights reserved.
//

import UIKit

let linkUrl = URL(string: "https://www.googleapis.com/youtube/v3/search?part=id,snippet&maxResults=20&channelId=UCCq1xDJMBRF61kiOgU90_kw&key=AIzaSyBRLPDbLkFnmUv13B-Hq9rmf0y7q8HOaVs")

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tableModelArray = [TableModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        manageDatasource()
    }
    
    func manageDatasource() {
        switch Network.reachability.status {
        case .wifi:
            //try to download data from server
            if let linkUrl = linkUrl {
                DownloadManager.downloadData(withUrl: linkUrl) { (modelArray, status) in
                    if status {
                        self.tableModelArray = modelArray ?? self.tableModelArray
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        default:
           DispatchQueue.main.async {
            self.tableModelArray = DatabaseManager.shared.getRecordFromTableInfo() ?? self.tableModelArray
            self.tableView.reloadData()
            }
            //try to upload data from database
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
        
    }
    
    @objc func statusManager(_ notification: Notification) {
        manageDatasource()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = tableModelArray[indexPath.row].title
        
        // get the deal image
        let imageUrl = tableModelArray[indexPath.row].url
        
        // reset reused cell image to placeholder
        cell.imageView?.image = UIImage(named: "Placeholder")
        cell.accessoryType = .disclosureIndicator
        var image = DownloadManager.getImage(forFile: self.tableModelArray[indexPath.row].youTubeId)
        
        // async image
        if image == nil {
            URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                if error == nil {
                    image = UIImage(data: data!)
                    DownloadManager.writeImage(withName: self.tableModelArray[indexPath.row].youTubeId, image!)
                    DispatchQueue.main.async {
                        cell.imageView?.image = image!
                    }
                }
            }.resume()
            } else {
            //placeholderImage
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let youtubeId = tableModelArray[indexPath.row].youTubeId {
        var youtubeUrl = URL(string:"youtube://\(youtubeId)")!
            if UIApplication.shared.canOpenURL(youtubeUrl) {
                UIApplication.shared.open(youtubeUrl, options: [ : ]) { (status) in
                    print("video successfully opened in app with status \(status)")
                }
        } else{
            youtubeUrl = URL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
                UIApplication.shared.open(youtubeUrl, options: [:]) { (status) in
                    print("video successfully opened in app with status \(status)")
                }
        }
        }
    }


}

