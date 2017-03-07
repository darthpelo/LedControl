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
    func yellowSwitch(isOn: Bool)
    func greenSwitch(isOn: Bool)
}

extension Bool {
    init<T: Integer>(_ num: T) {
        self.init(num != 0)
    }
}

struct Presenter {
    weak var view: ViewProtocol?
    
    func startUp() {
        let provider: MoyaProvider<MyService>! = MoyaProvider<MyService>()
        
        provider.request(.Status) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                // do something with the response data or statusCode
                let json = try? JSONSerialization.jsonObject(with: data as Data, options: []) as AnyObject
                
                if let y = json?["yellow"] as? String, let value = Int(y) {
                    self.view?.yellowSwitch(isOn: Bool(value))
                }
                
                if let g = json?["yellow"] as? String, let value = Int(g) {
                    self.view?.greenSwitch(isOn: Bool(value))
                }
            case let .failure(error):
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
                BPLog(object: error.errorDescription)
            }
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
