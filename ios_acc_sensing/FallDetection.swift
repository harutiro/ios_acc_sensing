//
//  FallDetection.swift
//  ios_acc_sensing
//
//  Created by k22120kk on 2023/07/14.
//

import Foundation

/// 転倒検知クラスです。
class FallDetection {
    var normData: [Double] = []
    let threshold: Double = 2 // 閾値

    /// 加速度データを追加して転倒を検知します。
    ///
    /// - Parameters:
    ///   - x: X軸方向の加速度
    ///   - y: Y軸方向の加速度
    ///   - z: Z軸方向の加速度
    /// - Returns: 転倒が検知された場合はtrue、そうでない場合はfalse
    func addAccelerationData(x: Double, y: Double, z: Double) -> Bool {
        // ノルムの計算
        let norm = calculateNorm(x: x, y: y, z: z)
        // print("norm: \(norm)")

        // ノイズ除去処理
        let noiseRemovedNorm = noiseRemoval(norm: norm)
        print("norm (noise removal): \(noiseRemovedNorm)")

        // ノルムデータの追加
        normData.append(noiseRemovedNorm)
        print("normData: \(normData.count)")

        // 最新のデータを含む5つのノルムデータを使用して転倒を判定
        if normData.count >= 5 {
            let isFalling = norm >= threshold
            if isFalling {
                // 降った場合の処理
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    /// ノルムを計算します。
    ///
    /// - Parameters:
    ///   - x: X軸方向の加速度
    ///   - y: Y軸方向の加速度
    ///   - z: Z軸方向の加速度
    /// - Returns: ノルムの値
    func calculateNorm(x: Double, y: Double, z: Double) -> Double {
        // ノルムの計算
        return sqrt(x * x + y * y + z * z)
    }

    /// ノイズ除去処理を行います。
    ///
    /// - Parameter norm: ノルムの値
    /// - Returns: ノイズ除去されたノルムの値
    func noiseRemoval(norm: Double) -> Double {
        // ノイズ除去処理の実装（過去の5つのデータの平均値を使用）
        if normData.count >= 5 {
            var sum = norm
            for i in normData.count - 4 ..< normData.count {
                sum += normData[i]
            }
            let average = sum / 5
            return average
        } else {
            return norm
        }
    }
}
