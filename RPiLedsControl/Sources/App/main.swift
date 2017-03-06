#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

// MARK: - Darwin / Xcode Support
#if os(OSX)
    private var O_SYNC: CInt { fatalError("Linux only") }
#endif

import Vapor

let drop = Droplet()

let service = GPIOService.sharedInstance
service.setup()

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
    case Command.Zero:
        service.powerOff()
    case Command.One:
        service.switchYellow(Command.One)
    case Command.Two:
        service.switchYellow(Command.Two)
		case Command.Three:
			  service.switchGreen(Command.Three)
		case Command.Four:
				service.switchGreen(Command.Four)
    default:
        throw Abort.badRequest
    }

    return returnJson()
    
    // return try JSON(node: [
    //     "version": "1.0.3",
    //     "command": "\(cmdId)",
    //     "yellow": "\(service.yellow)",
    //     "green": "\(service.green)"
    //     ])
}

drop.run()
