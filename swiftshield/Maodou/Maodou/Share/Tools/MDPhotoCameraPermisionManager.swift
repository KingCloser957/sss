//
//  OOPhotoCameraPermisionManager.swift
//  Orchid
//
//  Created by huangrui on 2022/8/9.
//

import Foundation
import UIKit
import Photos

class MDPhotoCameraPermisionManager: NSObject {

    private static let permisionManager = MDPhotoCameraPermisionManager()

    public class func shareInstance() -> MDPhotoCameraPermisionManager {
        return permisionManager
    }

    public func getCameraPermision(_ completion:@escaping ((_ finish:Bool) -> Void)) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { finish in
                DispatchQueue.main.async {
                    if finish {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } else if status == .authorized {
            completion(true)
        } else {
            completion(false)
        }
    }

    public func getPhotoPermision(_ completion:@escaping ((_ finish:String) -> Void)) {
        var statsus = PHPhotoLibrary.authorizationStatus()
        if #available(iOS 14, *) {
            statsus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            if statsus == .notDetermined {
                self.setPhotoPermision(completion)
            } else if statsus == .authorized {
                completion("1")
            } else if statsus == .limited {
                completion("limite")
            } else {
                completion("0")
            }
        } else {
            statsus = PHPhotoLibrary.authorizationStatus()
            if statsus == .notDetermined {
                self.setPhotoPermision(completion)
            } else if statsus == .authorized {
                completion("1")
            } else {
                completion("0")
            }
        }
    }

    private func setPhotoPermision(_ completion:@escaping ((_ finish:String) -> Void)) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if status == .limited {
                    completion("limite")
                } else if status == .authorized {
                    completion("1")
                } else {
                    completion("0")
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    completion("1")
                } else {
                    completion("0")
                }
            }
        }
    }
}
