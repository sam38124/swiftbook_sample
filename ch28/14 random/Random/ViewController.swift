//
//  ViewController.swift
//  Random
//
//  Created by KoKang Chu on 2018/6/22.
//  Copyright © 2018年 KoKang Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1...10 之間的整數
        let n = Int.random(in: 1...10)
        print(n)
        // 0...1 之間的小數
        let f = Float.random(in: 0...1)
        print(f)
        // 5...10 之間的小數
        let d = Double.random(in: 5...10)
        print(d)
        // 從字串中隨機挑選一個字元
        let s = "Hello".randomElement()
        print(s!)
    }


}

