//
//  ViewController.swift
//  Label
//
//  Created by KoKang Chu on 2017/6/25.
//  Copyright © 2017年 KoKang Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 設定 label 可以顯示兩行文字
        label.numberOfLines = 2
        
        let title1 = UIFont.preferredFont(forTextStyle: .title1)
        let footnote = UIFont.preferredFont(forTextStyle: .footnote)
        
        // 讓 hello 套用 title1 字型樣式
        let s1 = NSMutableAttributedString(string: "Hello\n",
                                           attributes: [
                                            NSAttributedString.Key.font : title1
            ])
        
        // 讓 第二行文字 套用 footnote 字型樣式以及藍色
        let s2 = NSAttributedString(string: "第二行文字",
                                    attributes: [
                                        NSAttributedString.Key.font : footnote,
                                        NSAttributedString.Key.foregroundColor: UIColor.blue
            ])
        
        // 將 s2 併到 s2
        s1.append(s2)
        
        // 顯示到 label 上
        label.attributedText = s1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

