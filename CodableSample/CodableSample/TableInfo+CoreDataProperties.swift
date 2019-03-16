//
//  TableInfo+CoreDataProperties.swift
//  CodableSample
//
//  Created by Aina Jain on 12/03/19.
//  Copyright © 2019 Aina Jain. All rights reserved.
//
//

import Foundation
import CoreData


extension TableInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TableInfo> {
        return NSFetchRequest<TableInfo>(entityName: "TableInfo")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var youTubeId: String?
    @NSManaged public var imagePath: String?

}
