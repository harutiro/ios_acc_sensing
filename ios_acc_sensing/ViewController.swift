//
//  ViewController.swift
//  ios_acc_sensing
//
//  Created by k22120kk on 2023/07/13.
//

import UIKit
import CoreMotion

/// メインビューコントローラー
class ViewController: UIViewController {
 
    /// モーションマネージャー
    let motionManager = CMMotionManager()
 
    /// X軸の加速度ラベル
    @IBOutlet var accelerometerX: UILabel!
    
    /// Y軸の加速度ラベル
    @IBOutlet var accelerometerY: UILabel!
    
    /// Z軸の加速度ラベル
    @IBOutlet var accelerometerZ: UILabel!
    
    /// ファイル名のラベル
    @IBOutlet var fileNameLabel: UILabel!
    
    /// 結果のラベル
    @IBOutlet var resultLabel: UILabel!
    
    /// 振ったかどうかを格納する変数
    var isShaked = false
    
    /// CSVの書き込み用
    var fileStorage: OtherFileStorage? = nil
    
    /// センサーデータの比較用
    var fallDetection: FallDetection? = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// センシングの状態が変更された時の処理
    @IBAction func sensingChanged(_ sender: UISwitch) {
        if(sender.isOn){
            fileStorage = OtherFileStorage(fileName: "\(DateUtils.getNowDate())_SensorData")
            fileNameLabel.text = "\(DateUtils.getNowDate())_SensorData"
            fallDetection = FallDetection()
            startAccelerometer()
        }else{
            stopAccelerometer()
            fallDetection = nil
            fileStorage = nil
        }
    }
    
    /// 加速度データを出力する
    func outputAccelData(acceleration: CMAcceleration){
        accelerometerX.text = String(format: "%06f", acceleration.x)
        accelerometerY.text = String(format: "%06f", acceleration.y)
        accelerometerZ.text = String(format: "%06f", acceleration.z)
        
        isShaked = fallDetection?.addAccelerationData(x: acceleration.x, y: acceleration.y, z: acceleration.z) ?? false
        resultLabel.text = isShaked ? "振ってる" : "振っていない"
        
        fileStorage?.doLog(text: "\(DateUtils.getTimeStamp()),\(acceleration.x),\(acceleration.y),\(acceleration.z)")
    }
    
    /// 加速度センサーのモニタリングを開始する
    func startAccelerometer(){
        if motionManager.isAccelerometerAvailable {
            // センサー値の取得間隔の設定 [sec]
//            motionManager.accelerometerUpdateInterval = 0.01
 
            // センサーデータの取得を開始
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: { (accelData: CMAccelerometerData?, error: Error?) in
                    self.outputAccelData(acceleration: accelData!.acceleration)
            })
        }
    }
 
    /// 加速度センサーのモニタリングを停止する
    func stopAccelerometer(){
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
