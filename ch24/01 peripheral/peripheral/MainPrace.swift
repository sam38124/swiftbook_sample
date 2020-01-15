//
//  MainPrace.swift
//  Peripheral
//
//  Created by 王建智 on 2019/7/25.
//  Copyright © 2019 KoKang Chu. All rights reserved.
//

import Cocoa
class MainPrace: NSViewController,NSTextFieldDelegate {
    var idcount=8
    
    @IBOutlet var RRT: NSTextField!
    @IBOutlet var RFT: NSTextField!
    @IBOutlet var LRT: NSTextField!
    @IBOutlet var LFT: NSTextField!
    @IBOutlet var LRL2: NSTextField!
    @IBOutlet var LRL1: NSTextField!
    @IBOutlet var LFL2: NSTextField!
    @IBOutlet var LFL1: NSTextField!
    @IBOutlet var RRL2: NSTextField!
    @IBOutlet var RRL1: NSTextField!
    @IBOutlet var RFL2: NSTextField!
    @IBOutlet var RFL1: NSTextField!
    @IBOutlet var LRI2: NSImageView!
    @IBOutlet var LRI1: NSImageView!
    @IBOutlet var LFI2: NSImageView!
    @IBOutlet var LFI1: NSImageView!
    @IBOutlet var RRI2: NSImageView!
    @IBOutlet var RRI1: NSImageView!
    @IBOutlet var RFI1: NSImageView!
    @IBOutlet var RFI2: NSImageView!
    @IBOutlet var Next: NSButton!
    @IBOutlet var reselect: NSButton!
    @IBOutlet var ProGramView: NSView!
    @IBOutlet var reoghtview: NSView!
    @IBOutlet var SelectAction: NSButton!
    @IBOutlet var selectpad: NSPopUpButton!
    override func viewDidLayout() {
         print("重繪\(view.bounds.size.width)")
        let screenSize = NSScreen.main!.frame.width
        print("螢幕寬度\(screenSize)")
//        if(view.bounds.size.width==screenSize){
//         test.image=NSImage.init(named: NSImage.Name.img_car)
//        }else{
//               test.image=NSImage.init(named: NSImage.Name.img_car95)
//        }
         let refont=RFI1.frame.width/168
         resize(LRL1,refont,14)
         resize(LRL2,refont,14)
         resize(RRL1,refont,14)
         resize(RRL2,refont,14)
         resize(RFL1,refont,14)
         resize(RFL2,refont,14)
         resize(LFL1,refont,14)
         resize(LFL2,refont,14)
         resize(RRT,refont,16)
         resize(RFT,refont,16)
         resize(LFT,refont,16)
         resize(LRT,refont,16)
//        RFL1.bounds.size=NSSize(width: RFL1.frame.width, height: 18*refont)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LFL1.delegate=self
        RFL1.delegate=self
        RRL2.delegate=self
        LRL2.delegate=self
 reoghtview.wantsLayer=true
        reoghtview.layer?.backgroundColor = .white
        ProGramView.wantsLayer=true
    ProGramView.layer?.backgroundColor = .init(red: 132/255, green: 132/255, blue: 137/255, alpha: 1)
        selectpad.bezelColor = .gray
        selectpad.contentTintColor = .black
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        SelectAction.attributedTitle = NSAttributedString(string: "LF_PAD", attributes: [ NSAttributedStringKey.foregroundColor : NSColor.white, NSAttributedStringKey.paragraphStyle : pstyle ])
        let pstyle2 = NSMutableParagraphStyle()
        pstyle2.alignment = .center
        Next.attributedTitle = NSAttributedString(string: "Next", attributes: [ NSAttributedStringKey.foregroundColor : NSColor.white, NSAttributedStringKey.paragraphStyle : pstyle2 ])
        reselect.attributedTitle = NSAttributedString(string: "Reselect", attributes: [ NSAttributedStringKey.foregroundColor : NSColor.white, NSAttributedStringKey.paragraphStyle : pstyle2 ])
       
    }
    
    @IBAction func openaction(_ sender: Any) {
        selectpad.performClick(self)
    }
    @ objc func Update(){}
    
    @IBAction func change(_ sender: Any) {
      
    }
    func resize(_ la:NSTextField,_ refont:CGFloat,_ size:CGFloat){
        if(la.placeholderString != nil){
             la.SetPlaceText(size*refont, .white, la.placeholderString!)
        }
        la.font = NSFont.systemFont(ofSize: size*refont)
        la.sizeToFit()
    }
    
    override func controlTextDidChange(_ notification: Notification) {
        if let textField = notification.object as? NSTextField {
            let string=textField.stringValue
let aSet = NSCharacterSet(charactersIn:"0123456789abcdef").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if(string != numberFiltered||string.count>idcount){
                textField.stringValue=String(string.prefix((string.count-1)))
            }
            print(textField.stringValue)
            //do what you need here
        }
    }
}
