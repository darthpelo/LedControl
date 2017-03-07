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
    case YellowOn
    case YellowOff
    case GreenOn
    case GreenOff
}

enum MyService {
    case YellowOn
    case YellowOff
    case GreenOn
    case GreenOff
    case Off
    case Led(type: Leds, isOn: Bool)
}

// MARK: - TargetType Protocol Implementation
extension MyService: TargetType {
    var baseURL: URL { return URL(string: "http://darthpelo.myddns.me/")! }
    var path: String {
        switch self {
        case .Led(_, _):
            return "/led"
        case .Off:
            return "cmd/\(Leds.Off.rawValue)"
        case .YellowOn:
            return "cmd/\(Leds.YellowOn.rawValue)"
        case .YellowOff:
            return "cmd/\(Leds.YellowOff.rawValue)"
        case .GreenOn:
            return "cmd/\(Leds.GreenOn.rawValue)"
        case .GreenOff:
            return "cmd/\(Leds.GreenOff.rawValue)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Led, .YellowOn, .YellowOff, .GreenOn, .GreenOff, .Off:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .YellowOn, .YellowOff, .GreenOn, .GreenOff, .Off:
            return nil
        case .Led(let type, let isOn):
            return ["type": type.rawValue, "isOn": isOn]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        switch self {
        case .Off:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .YellowOn, .YellowOff:
            return "Yellow".utf8Encoded
        case .GreenOn, .GreenOff:
            return "Green".utf8Encoded
        case .Led(let type, let isOn):
            return "{\"type\": \"\(type.rawValue)\", \"isOn\": \"\(isOn)\"}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .Led, .YellowOn, .YellowOff, .GreenOn, .GreenOff, .Off:
            return .request
        }
    }
}
