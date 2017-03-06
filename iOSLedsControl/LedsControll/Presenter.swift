//
//  Presenter.swift
//  LedsControl
//
//  Created by Alessio Roberto on 28/01/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import Moya

protocol ViewProtocol: class {
    func resetAllSwitches()
}

struct Presenter {
    weak var view: ViewProtocol?
    
    func startUp() {
        let provider: MoyaProvider<MyService>! = MoyaProvider<MyService>()
        
        provider.request(.Off) { (result) in
            BPLog(object: result)
        }
    }
    
    func yellowSwitch(isOn: Bool) {
        let provider: MoyaProvider<MyService>! = MoyaProvider<MyService>()
        
        if isOn {
            provider.request(.YellowOn) { (result) in
                BPLog(object: result)
            }
        } else {
            provider.request(.YellowOff) { (result) in
                BPLog(object: result)
            }
        }
    }
    
    func greenSwitch(isOn: Bool) {
        let provider: MoyaProvider<MyService>! = MoyaProvider<MyService>()
        
        if isOn {
            provider.request(.GreenOn) { (result) in
                BPLog(object: result)
            }
        } else {
            provider.request(.GreenOff) { (result) in
                BPLog(object: result)
            }
        }
    }
}
