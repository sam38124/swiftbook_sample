//
//  PhotoTransformer.swift
//  Transformable
//
//  Created by KoKang Chu on 2018/8/7.
//  Copyright © 2018年 KoKang Chu. All rights reserved.
//

import UIKit

class PhotoTransformer: ValueTransformer {
    // 將自訂類別（型態）轉成 Data
    override func transformedValue(_ value: Any?) -> Any? {
        if let value = value {
            return try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        }
        
        return nil
    }
    
    // 將 Data 還原為原本的類別（型態）
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let value = value {
            return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value as! Data)
        }
        
        return nil
    }
}
