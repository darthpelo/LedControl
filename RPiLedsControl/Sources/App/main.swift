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

    try service.execute(command: cmdId)

    guard let json = returnJson(forCommand: cmdId) else {
      throw Abort.badRequest
    }

    return json
}

drop.get("status") { request in
  guard let json = returnJson(forCommand: nil) else {
    throw Abort.badRequest
  }

  return json
}

drop.run()
