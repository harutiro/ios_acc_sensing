//
//  OtherFileStrage.swift
//  ios_acc_sensing
//
//  Created by k22120kk on 2023/07/13.
//

import Foundation

class OtherFileStorage {
    let fileAppend: Bool = true // true=追記, false=上書き
    var fileName: String = "SensorLog"
    let fileExtension: String = "csv"
    var filePath: URL?
    let dimension: Int = 3

    init(
        fileName:String
    ) {
        
        self.fileName = fileName
        
        setupFilePath()
        
        if !FileManager.default.fileExists(atPath: filePath?.path ?? "") {
            FileManager.default.createFile(atPath: filePath?.path ?? "", contents: nil, attributes: nil)
        }
        writeText(firstLog(dimension), filePath)
    }

    func doLog(text: String) {
        writeText("\(text)", filePath)
    }

    private func setupFilePath() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        filePath = documentsDirectory?.appendingPathComponent(fileName).appendingPathExtension(fileExtension)


        print(filePath?.absoluteString)
        
    }

    private func firstLog(_ dimension: Int) -> String {
        switch dimension {
        case 1:
            return "time,x"
        case 2:
            return "time,x,y"
        case 3:
            return "time,x,y,z"
        default:
            var result = "time"
            for i in 0..<dimension {
                result += ",\(i)"
            }
            return result
        }
    }

    private func writeText(_ text: String, _ path: URL?) {
        guard let filePath = path else {
            print("Invalid file path.")
            return
        }

        do {
            let fileHandle = try FileHandle(forWritingTo: filePath)
            fileHandle.seekToEndOfFile()
            fileHandle.write((text + "\n").data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {
            print("Error writing to file: \(error)")
        }
    }
}
