//
//  MyService.swift
//  LedsControl
//
//  Created by Alessio Roberto on 28/01/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import Moya

enum Leds: Int {
    case Off
    case Yellow
    case Green
}

enum MyService {
    case zen
    case yellow
    case green
    case off
    case led(type: Leds, isOn: Bool)
}

// MARK: - TargetType Protocol Implementation
extension MyService: TargetType {
//    var baseURL: URL { return URL(string: "http://darthpelo.myddns.me/")! }
    var baseURL: URL { return URL(string: "http://10.230.192.100")! }
    var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .led(_, _):
            return "/led"
        case .off:
            return "cmd/\(Leds.Off.rawValue)"
        case .yellow:
            return "cmd/\(Leds.Yellow.rawValue)"
        case .green:
            return "cmd/\(Leds.Green.rawValue)"
        }
    }
    var method: Moya.Method {
        switch self {
        case .zen, .led, .yellow, .green, .off:
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .zen, .yellow, .green, .off:
            return nil
        case .led(let type, let isOn):
            return ["type": type.rawValue, "isOn": isOn]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        switch self {
        case .zen, .off:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .yellow:
            return "Yellow".utf8Encoded
        case .green:
            return "Green".utf8Encoded
        case .led(let type, let isOn):
            return "{\"type\": \"\(type.rawValue)\", \"isOn\": \"\(isOn)\"}".utf8Encoded
        }
    }
    var task: Task {
        switch self {
        case .zen, .led, .yellow, .green, .off:
            return .request
        }
    }
}
