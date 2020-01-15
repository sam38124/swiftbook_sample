//
//  Photo.swift
//  Transformable
//
//  Created by KoKang Chu on 2018/8/7.
//  Copyright © 2018年 KoKang Chu. All rights reserved.
//

import UIKit

class Photo: NSObject, NSCoding {
    // 圖片
    var image: UIImage?
    // 圖片說明
    var title: String?
    
    override init() {
        
    }
    
    // 編碼
    func encode(with aCoder: NSCoder) {
        let imageData = image!.jpegData(compressionQuality: 0.9)
        aCoder.encode(imageData, forKey: "image")
        aCoder.encode(title, forKey: "title")
    }
    
    // 解碼
    required init?(coder aDecoder: NSCoder) {
        image = UIImage(data: aDecoder.decodeObject(forKey: "image") as! Data)
        title = aDecoder.decodeObject(forKey: "title") as? String
    }
    
}
