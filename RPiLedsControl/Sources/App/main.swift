#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import Vapor
import GpioService

extension Optional {
	// `then` function executes the closure if there is some value
	func then(_ handler: (Wrapped) -> Void) {
		switch self {
		case .some(let wrapped): return handler(wrapped)
		case .none: break
		}
	}
}

enum Command {
    static let Zero = 0
    static let One = 1
    static let Two = 2
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

		let service = GpioService()

    switch(cmdId) {
    case Command.Zero:
        service.powerOff()
    case Command.One:
        service.yellow()
    case Command.Two:
        service.green()
    default:
        throw Abort.badRequest
    }

    return try JSON(node: [
        "version": "1.0.3",
        "command": "\(cmdId)",
        "yellow": "\(service.yellow))",
        "green": "\(service.green))"
        ])
}

drop.run()
