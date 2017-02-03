//
//  Function.swift
//  LedsControl
//
//  Created by Alessio Roberto on 03/02/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation

func BPLog<T>(object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
        let process = ProcessInfo.processInfo
        let threadId = "?"
        print("\(dateFormatter.string(from: Date())) \(process.processName) [\(process.processIdentifier):\(threadId)] \(funcname):\r\t\(object)\n")
    #endif
}
