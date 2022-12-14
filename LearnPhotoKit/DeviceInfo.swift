//
//  DeviceInfo.swift
//  LearnPhotoKit
//
//  Created by Brook_Mobius on 2022/11/4.
//

import Foundation
import UIKit

struct DeviceInfo {
    static func deviceRemainingFreeSpaceInBytes() -> NSNumber {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath[0])
            print(systemAttributes[.systemFreeSize] as! NSNumber)
        } catch {
            print(error)
        }
        
        return 0 as NSNumber
    }
    
    static func deviceRemainingFreeSpaceInBytes_resourceValues() {
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            if let capacity = values.volumeAvailableCapacityForImportantUsage {
                print("Available capacity for important usage: \(Int64(capacity).fileSizeFormatted)")
            } else {
                print("Capacity is unavailable")
            }
        } catch {
            print("Error retrieving capacity: \(error.localizedDescription)")
        }
        
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
            if let capacity = values.volumeTotalCapacity {
                print("volumeTotalCapacity: \(Int64(capacity).fileSizeFormatted)")
            } else {
                print("Capacity is unavailable")
            }
        } catch {
            print("Error retrieving capacity: \(error.localizedDescription)")
        }
        
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
            if let capacity = values.volumeAvailableCapacityForOpportunisticUsage {
                print("volumeAvailableCapacityForOpportunisticUsage: \(Int64(capacity).fileSizeFormatted)")
            } else {
                print("Capacity is unavailable")
            }
        } catch {
            print("Error retrieving capacity: \(error.localizedDescription)")
        }
    }
    
    static var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
    }
}

extension UIDevice {
    var systemSize: Int64? {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let totalSize = (systemAttributes[.systemSize] as? NSNumber)?.int64Value else {
                return nil
        }

        return totalSize
    }

    var systemFreeSize: Int64? {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let freeSize = (systemAttributes[.systemFreeSize] as? NSNumber)?.int64Value else {
                return nil
        }

        return freeSize
    }
}

extension Int64 {
    var fileSizeFormatted: String {
        return convertByteToHumanReadable(self)
    }
}

extension DeviceInfo {
    static func test() {
        deviceRemainingFreeSpaceInBytes_resourceValues()
        
        print("directory attributes free", UIDevice.current.systemFreeSize?.fileSizeFormatted ?? "")
        print(UIDevice.current.systemSize?.fileSizeFormatted ?? "")
        
        print("directory attributes total", totalDiskSpaceInBytes.fileSizeFormatted)
    }
}

/*
 public struct Luminous {
 
 }
 
 extension Luminous {
 
 // MARK: Disk
 
 /// Disk information.
 public struct Disk {
 
 // The credits for these functions are to Cuong Lam for this SO answer : http://stackoverflow.com/a/29417855/588967
 private static func MBFormatter(_ bytes: Int64) -> String {
 let formatter = ByteCountFormatter()
 formatter.allowedUnits = ByteCountFormatter.Units.useMB
 formatter.countStyle = ByteCountFormatter.CountStyle.decimal
 formatter.includesUnit = false
 return formatter.string(fromByteCount: bytes) as String
 }
 
 /// The total disk space in string format (megabytes).
 @available(*, deprecated, message: "Use totalSpace(measureUnit:) instead.")
 public static var totalSpace: String {
 return ByteCountFormatter.string(fromByteCount: totalSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
 }
 
 /// The free disk space in string format (megabytes).
 @available(*, deprecated, message: "Use freeSpace(measureUnit:) instead.")
 public static var freeSpace: String {
 return ByteCountFormatter.string(fromByteCount: freeSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
 }
 
 /// The used disk space in string format (megabytes).
 @available(*, deprecated, message: "Use usedSpace(measureUnit:) instead.")
 public static var usedSpace: String {
 return ByteCountFormatter.string(fromByteCount: usedSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
 }
 
 /// The total disk space in bytes. 0 if something went wrong.
 public static var totalSpaceInBytes: Int64 {
 do {
 let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
 let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
 return space!
 } catch {
 return 0
 }
 }
 
 /// The free disk space in bytes. 0 if something went wrong.
 public static var freeSpaceInBytes: Int64 {
 do {
 let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
 let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
 return freeSpace!
 } catch {
 return 0
 }
 }
 
 /// The used disk space in bytes. 0 if something went wrong.
 @available(*, deprecated, message: "Use usedSpace(measureUnit:) instead.")
 public static var usedSpaceInBytes: Int64 {
 let usedSpace = totalSpaceInBytes - freeSpaceInBytes
 return usedSpace
 }
 
 /// The free disk space in percentage.
 @available(*, deprecated, message: "Use freeSpace(measureUnit:) instead.")
 public static var freeSpaceInPercentage: Float {
 
 let freeSpace = Float(freeSpaceInBytes)
 let totalSpace = Float(totalSpaceInBytes)
 
 return (freeSpace * 100) / totalSpace
 }
 
 /// The used disk space in percentage.
 public static var usedSpaceInPercentage: Float {
 
 let usedSpace = Float(usedSpaceInBytes)
 let totalSpace = Float(totalSpaceInBytes)
 
 return (usedSpace * 100) / totalSpace
 }
 
 /// The total space of the internal disk.
 /// - Parameter measureUnit: The measure unit. If `percentage` the return value will be `100.0`.
 public static func totalSpace(measureUnit: MeasureUnit = .bytes) -> Double {
 
 switch measureUnit {
 case .bytes:
 return Double(totalSpaceInBytes)
 case .kilobytes:
 return Double(totalSpaceInBytes / 1024)
 case .megabytes:
 return Double(totalSpaceInBytes / 1024 / 1024)
 case .gigabytes:
 return Double(totalSpaceInBytes / 1024 / 1024 / 1024)
 case .percentage:
 return 100.0
 }
 }
 
 /// The used space of the internal disk.
 /// - Parameter measureUnit: The measure unit.
 public static func usedSpace(measureUnit: MeasureUnit = .bytes) -> Double {
 
 switch measureUnit {
 case .bytes:
 return Double(usedSpaceInBytes)
 case .kilobytes:
 return Double(usedSpaceInBytes / 1024)
 case .megabytes:
 return Double(usedSpaceInBytes / 1024 / 1024)
 case .gigabytes:
 return Double(usedSpaceInBytes / 1024 / 1024 / 1024)
 case .percentage:
 return Double(((usedSpaceInBytes * 100) / totalSpaceInBytes))
 }
 }
 
 /// The free space of the internal disk.
 /// - Parameter measureUnit: The measure unit.
 public static func freeSpace(measureUnit: MeasureUnit = .bytes) -> Double {
 
 switch measureUnit {
 case .bytes:
 return Double(freeSpaceInBytes)
 case .kilobytes:
 return Double(freeSpaceInBytes / 1024)
 case .megabytes:
 return Double(freeSpaceInBytes / 1024 / 1024)
 case .gigabytes:
 return Double(freeSpaceInBytes / 1024 / 1024 / 1024)
 case .percentage:
 return Double(((freeSpaceInBytes * 100) / totalSpaceInBytes))
 }
 }
 }
 }
 */
