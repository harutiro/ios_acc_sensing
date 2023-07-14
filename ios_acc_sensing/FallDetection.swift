//
//  FallDetection.swift
//  ios_acc_sensing
//
//  Created by k22120kk on 2023/07/14.
//

import Foundation

class FallDetection {
    var normData: [Double] = []
    let threshold: Double = 2 // 閾値

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

        // 最新のデータを含む5つのノルムデータを使用して降ったかどうかを判定
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

    func calculateNorm(x: Double, y: Double, z: Double) -> Double {
        // ノルムの計算
        return sqrt(x * x + y * y + z * z)
    }

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
