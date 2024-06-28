//
//  MDGuidanceManager.swift
//  Maodou
//
//  Created by KingCloser on 2024/6/1.
//

import UIKit

struct MDGuidanceModel {
    var des:String?
    var guidanceView:UIView?
}

class MDGuidanceManager: NSObject {
    
    static let shared = MDGuidanceManager()
    var datas:[MDGuidanceModel] = []
    var showIndex:Int = 0
    
    func addGuidanceItem(item:MDGuidanceModel) {
        datas.append(item)
    }
    
    func needShow() -> Bool {
        return !UserDefaults.standard.bool(forKey: "GuidanceFirstShow")
    }
    
    func markShow() {
        UserDefaults.standard.set(true, forKey: "GuidanceFirstShow")
        UserDefaults.standard.synchronize()
    }
    
    func canShowNext() -> Bool {
        if self.datas.count == 1 {
            return false
        } else {
            return datas.count > showIndex
        }
    }
    
    func clearAllGuidanceModel() {
        self.showIndex = -1
        self.datas.removeAll()
    }
    
    func getNextGuidanceModel() -> MDGuidanceModel? {
        if self.showIndex + 1 < self.datas.count {
            self.showIndex+=1
            return self.datas[showIndex]
        }
        return nil
    }
    
    func beginGuidance(with topView:UIView) {
        if self.datas.count > 0 {
            let model = self.datas[showIndex]
            if let view = model.guidanceView as? MDGuidanceStepOneView {
                view.nextBlock = {[weak self,weak view] in
                    view?.removeFromSuperview()
                    if let nextModel = self?.getNextGuidanceModel(),
                       let twoView = nextModel.guidanceView as? MDGuidanceStepTwoView {
                        twoView.nextBlock = { [weak self,weak twoView] in
                            twoView?.removeFromSuperview()
                            if let threeModel = self?.getNextGuidanceModel(),
                               let threeView = threeModel.guidanceView as? MDGuidanceStepThreeView {
                                threeView.nextBlock = { [weak self,weak threeView] in
                                    threeView?.removeFromSuperview()
                                    self?.markShow()
                                }
                                topView.addSubview(threeView)
                            }
                        }
                        topView.addSubview(twoView)
                    }
                }
                topView.addSubview(view)
            }
        }
    }
}
