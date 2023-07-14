//
//  ViewController.swift
//  ios_acc_sensing
//
//  Created by k22120kk on 2023/07/13.
//


import UIKit
import CoreMotion
 
class ViewController: UIViewController {
 
    // MotionManager
    let motionManager = CMMotionManager()
 
    // 3 axes
    @IBOutlet var accelerometerX: UILabel!
    @IBOutlet var accelerometerY: UILabel!
    @IBOutlet var accelerometerZ: UILabel!
    @IBOutlet var fileNameLavel: UILabel!
    @IBOutlet var resultLavel: UILabel!
    
    
    /// 振ったかどうか格納するラベル
    var isShaked = false
    
    ///  csvの書き込み用
    var fileStorage:OtherFileStorage? = nil
    
    ///　センサーデータの比較用
    var fallDetection:FallDetection? = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
    }
    
    @IBAction func sensingChenged(_ sender: UISwitch) {
        if(sender.isOn){
            fileStorage = OtherFileStorage(fileName: "\(DateUtils.getNowDate())_SensorData")
            fileNameLavel.text = "\(DateUtils.getNowDate())_SensorData"
            fallDetection = FallDetection()
            startAccelerometer()
        }else{
            stopAccelerometer()
            fallDetection = nil
            fileStorage = nil
        }
    }
    
 
    func outputAccelData(acceleration: CMAcceleration){
        // 加速度センサー [G]
        accelerometerX.text = String(format: "%06f", acceleration.x)
        accelerometerY.text = String(format: "%06f", acceleration.y)
        accelerometerZ.text = String(format: "%06f", acceleration.z)
        
        
        isShaked = fallDetection?.addAccelerationData(x:acceleration.x , y: acceleration.y, z: acceleration.z) ?? false
        resultLavel.text = isShaked ? "振ってる" : "振っていない"
        print(isShaked)
        
        
        fileStorage?.doLog(text: "\(DateUtils.getTimeStamp()),\(acceleration.x),\(acceleration.y),\(acceleration.z)")
    }
    
    func startAccelerometer(){
        if motionManager.isAccelerometerAvailable {
            // intervalの設定 [sec]
//            motionManager.accelerometerUpdateInterval = 0.01
 
            // センサー値の取得開始
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.outputAccelData(acceleration: accelData!.acceleration)
            })
 
        }
    }
 
    // センサー取得を止める場合
    func stopAccelerometer(){
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
    }
}

