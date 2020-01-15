//
//  Entity+CoreDataProperties.swift
//  Transformable
//
//  Created by KoKang Chu on 2018/8/7.
//  Copyright © 2018年 KoKang Chu. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var photoObject: NSObject?

}
