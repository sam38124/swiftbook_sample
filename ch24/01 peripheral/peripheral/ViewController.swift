//
//  ViewController.swift
//  Peripheral
//
//  Created by KoKang Chu on 2017/7/17.
//  Copyright © 2017年 KoKang Chu. All rights reserved.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    enum SendDataError: Error {
        case CharacteristicNotFound
    }
    
    
    @IBOutlet var content: NSTextView!
    @IBOutlet var connectname: NSTextField!
    
    @IBOutlet var id4: NSTextField!
    @IBOutlet var id3: NSTextField!
    @IBOutlet var id2: NSTextField!
    @IBOutlet var id1: NSTextField!
    let C001_CHARACTERISTIC = "8D81"
    var connectblename=""
    var centralManager: CBCentralManager!
    // 儲存連上的 peripheral，此變數一定要宣告為全域
    var connectPeripheral: CBPeripheral!
    // 記錄所有的 characteristic
    var charDictionary = [String: CBCharacteristic]()
    
    /* 當 central 端重新執行後，嘗試取回 peripheral */
    func isPaired() -> Bool {
        let user = UserDefaults.standard
        if let uuidString = user.string(forKey: "KEY_PERIPHERAL_UUID") {
            let uuid = UUID(uuidString: uuidString)
            let list = centralManager.retrievePeripherals(withIdentifiers: [uuid!])
            if list.count > 0 {
                connectPeripheral = list.first!
                connectPeripheral.delegate = self
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unpair()
        // Do any additional setup after loading the view, typically from a nib.
        let queue = DispatchQueue.global()
        // 將觸發1號method
        centralManager = CBCentralManager(delegate: self, queue: queue)
    }
    
    /* 1號method */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // 先判斷藍牙是否開啟，如果不是藍牙4.x ，也會傳回電源未開啟
        guard central.state == .poweredOn else {
            // iOS 會出現對話框提醒使用者
            return
        }
        
        if isPaired() {
            // 將觸發 3號method
            centralManager.connect(connectPeripheral, options: nil)
        } else {
            // 將觸發 2號method
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    /* 2號method */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let deviceName = peripheral.name else {
            return
        }
        DispatchQueue.main.async {
            self.content.string=self.content.string+"\n:"+"找到藍牙裝置: \(deviceName)"
            self.connectblename=self.connectname.stringValue
           
        }
        guard deviceName.range(of: self.connectblename) != nil
            else {
                return
        }
      
        
        central.stopScan()
        
        // 斷線處理
        // 儲存周邊端的UUID，重新連線時需要這個值
        let user = UserDefaults.standard
        user.set(peripheral.identifier.uuidString, forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        
        connectPeripheral = peripheral
        connectPeripheral.delegate = self
        
        // 將觸發 3號method
        centralManager.connect(connectPeripheral, options: nil)
    }
    
    /* 3號method */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // 清除上一次儲存的 characteristic 資料
        charDictionary = [:]
        // 將觸發 4號method
        peripheral.discoverServices(nil)
    }
    
    /* 4號method */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("ERROR: \(#file, #function)")
            print(error!.localizedDescription)
            return
        }
        
        for service in peripheral.services! {
            // 將觸發 5號method
            connectPeripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /* 5號method */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("ERROR: \(#file, #function)")
            print(error!.localizedDescription)
            return
        }
        
        for characteristic in service.characteristics! {
            let uuidString = characteristic.uuid.uuidString
            charDictionary[uuidString] = characteristic
            if(uuidString=="8D81"){connectPeripheral.setNotifyValue(true, for: characteristic)}
            DispatchQueue.main.async {
               self.content.string=self.content.string+"\n:"+"找到UUID: \(uuidString)"
            }
   
        }
    }
    
    /* 將資料傳送到 peripheral */
    func sendData(_ data: Data, uuidString: String, writeType: CBCharacteristicWriteType)  {
        guard let characteristic = charDictionary[uuidString] else {
            mytool().WriteError()
            return
        }
        connectPeripheral.writeValue(
            data,
            for: characteristic,
            type: writeType
        )
    }
    
    /* 將資料傳送到 peripheral 時如果遇到錯誤會呼叫 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("寫入資料錯誤: \(error!)")
        }
    }
    
    /* 取得 peripheral 送過來的資料 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("ERROR: \(#file, #function)")
            print(error!)
            return
        }
        let data = characteristic.value
        //            let string = "> " + String(data: data as Data, encoding: .utf8)!
        print("收到數據ㄦ---------")
        for i in 0...data!.count-1{
            print(String(format:"%02X",data![i]))
        }
    }
    
   
 
    @IBAction func sendout(_ sender: Any) {
        if(id1.stringValue.count<6||id1.stringValue.count>8){mytool().info();return}
        if(id2.stringValue.count<6||id2.stringValue.count>8){mytool().info();return}
        if(id3.stringValue.count<6||id3.stringValue.count>8){mytool().info();return}
        if(id4.stringValue.count<6||id4.stringValue.count>8){mytool().info();return}
        var bt:[UInt8]=[0x60,0xA2,0x00,0xFF,0xFF,0xFF,0xFF,0xC2,0x0A]
        var data = Data(bytes: bt)
        content.string=content.string+"\n:"+mytool().DataString(bt, 8)
        sendData(data, uuidString:"8D81", writeType: .withResponse)
        usleep(200000)
        for i in 0..<4{
            switch i{
            case 0:
                bt=mytool().Setire(0x01, id1.stringValue)
                break
            case 1:
                bt=mytool().Setire(0x02, id2.stringValue)
                break
            case 2:
                bt=mytool().Setire(0x03, id3.stringValue)
                break
            case 3:
                bt=mytool().Setire(0x04, id4.stringValue)
                break
            default:
                break
            }
            data = Data(bytes: bt)
            sendData(data, uuidString:"8D81", writeType: .withResponse)
            content.string=content.string+"\n:"+mytool().DataString(bt, 8)
            usleep(200000)
        }
        bt=[0x60,0xA2,0xFF,0xFF,0xFF,0xFF,0xFF,0x3D,0x0A]
        //        bt=[0x53,0xA9,0x01,0xFF,0xFF,0xFF,0xFF,0xFB,0x0A]
        data = Data(bytes: bt)
        let bytes = [UInt8](data)
        print("送出\(bytes)")
        sendData(data, uuidString:"8D81", writeType: .withResponse)
content.string=content.string+"\n:"+mytool().DataString(bt, 8)
    }
    
    /* 向 periphral 送出讀資料請求 */
    @IBAction func readDataClick(_ sender: Any) {
        let characteristic = charDictionary[C001_CHARACTERISTIC]!
        connectPeripheral.readValue(for: characteristic)
    }
    
    
    /* 斷線處理 */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("連線中斷")
        if isPaired() {
            // 將觸發 3號method
            centralManager.connect(connectPeripheral, options: nil)
        }
    }
    
    /* 解配對 */
    func unpair() {
        let user = UserDefaults.standard
        user.removeObject(forKey: "KEY_PERIPHERAL_UUID")
        user.synchronize()
        if(centralManager) != nil{
            centralManager.cancelPeripheralConnection(connectPeripheral)
        }
        // 在 iOS 中要提醒使用者必須從系統設定中「忘記裝置」，否則無法再配對
    }
    
    @IBAction func unpairClick(_ sender: Any) {
        unpair()
    }
    
   
    

}

