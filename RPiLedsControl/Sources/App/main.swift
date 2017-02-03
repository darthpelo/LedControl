import Vapor
import Glibc
import SwiftyGPIO
import SwiftGPIOLibrary

enum Command: Int {
    case Zero
    case One
    case Two
}

let gpioLib = GPIOLib.sharedInstance
// Setup pin 20 and 26 as output with value 0
let list: [GPIOName] = [.P20, .P26]
let ports = gpioLib.setupOUT(ports: list, for: .RaspberryPi2)

func status(_ port: GPIO?) -> Int {
    guard let port = port else {
        return 0
    }
    
    return port.value
}

func yellow() {
    if (status(ports[.P20]) == 0) {
        gpioLib.switchOn(ports: [.P20])
    } else {
        gpioLib.switchOff(ports: [.P20])
    }
}

func green() {
    if (status(ports[.P26]) == 0) {
        gpioLib.switchOn(ports: [.P26])
    } else {
        gpioLib.switchOff(ports: [.P26])
    }
}

func powerOff() {
    gpioLib.switchOff(ports: list)
}

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"]
        ])
}

drop.get("cmd", ":id") { request in
    guard let cmdId = request.parameters["id"]?.int else {
        throw Abort.badRequest
    }
    
    switch(cmdId) {
    case Command.Zero.rawValue:
        powerOff()
    case Command.One.rawValue:
        yellow()
    case Command.Two.rawValue:
        green()
    default:
        throw Abort.badRequest
    }
    
    return try JSON(node: [
        "version": "1.0.0",
        "command": "\(cmdId)",
        "yellow": "\(status(ports[.P20]))",
        "green": "\(status(ports[.P26]))"
        ])
}

drop.resource("posts", PostController())

drop.run()
