//
//  ParseData.swift
//  CodableSample
//
//  Created by Aina Jain on 10/03/19.
//  Copyright © 2019 Aina Jain. All rights reserved.
//
import UIKit

class TableModel {
    var title : String?
    var url : URL?
    var youTubeId : String?
    var imagePath : String?

    convenience init(title: String, url: URL, youTubeId: String, imagePath : String) {
        self.init()
        self.title = title
        self.url = url
        self.youTubeId = youTubeId
        self.imagePath = imagePath
    }
    
    convenience init(withData data: TableInfo) {
        self.init()
        self.title = data.title
        self.url = URL(string: data.url!)
        self.youTubeId = data.youTubeId
        self.imagePath = data.imagePath
    }
}

struct InfoModel : Codable {
    struct Items : Codable {
        struct Snippet : Codable {
            struct Thumbnail : Codable {
                struct Medium : Codable {
                    let url: String
                    private enum CodingKeys : String, CodingKey {
                        case url
                    }
                }
                let medium: Medium
                private enum CodingKeys : String, CodingKey {
                    case medium
                }
            }
            let title: String
            let thumbnails: Thumbnail
            private enum CodingKeys : String, CodingKey {
                case title,
                     thumbnails
            }
        }
        struct ID : Codable {
            let videoId: String
            private enum CodingKeys : String, CodingKey {
                case videoId
            }
        }
        let snippet: Snippet
        let id: ID
        private enum CodingKeys : String, CodingKey {
            case snippet,id
        }
    }
    let items: [Items]
    private enum CodingKeys : String, CodingKey {
        case items
    }
}

