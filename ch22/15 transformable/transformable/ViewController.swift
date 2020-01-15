//
//  ViewController.swift
//  Transformable
//
//  Created by KoKang Chu on 2018/8/7.
//  Copyright © 2018年 KoKang Chu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func saveButton(_ sender: Any) {
        let viewContext = app.persistentContainer.viewContext
        // 宣告 photo 陣列
        let photo = [Photo()]
        photo[0].image = UIImage(named: "sample")
        photo[0].title = "美麗的風景"
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Entity",
                                                         into: viewContext) as! Entity
        
        entity.photoObject = photo as NSObject?
        
        app.saveContext()
    }
    
    @IBAction func loadButton(_ sender: Any) {
        let viewContext = app.persistentContainer.viewContext
        do {
            let allData = try viewContext.fetch(Entity.fetchRequest())
            let entity = allData.first as! Entity
            for photo in entity.photoObject as! [Photo] {
                imageView.image = photo.image
                label.text = photo.title
            }
        } catch {
            print(error)
        }
    }
}

