#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import Vapor

enum Err: Error {
    case InternalError
}

private func typeCheck(value: Any?) throws -> String {
  guard let value = value else { throw Err.InternalError }

  if value is String {
      return value as! String
  } else if value is Int {
      return "\(value)"
  } else {
      throw Err.InternalError
  }
}

func returnJson(forCommand cmd: Any?) -> JSON? {
  do {
    let command = try typeCheck(value: cmd)

    let service = GPIOService.sharedInstance

    return try? JSON(node: [
        "version": "1.1.0",
        "command": command,
        "yellow": "\(service.yellow)",
        "green": "\(service.green)"
        ])
  } catch {
    return try? JSON(node: [
        "version": "1.1.0",
        "command": "",
        "yellow": "\(service.yellow)",
        "green": "\(service.green)"
        ])
  }
}

// MARK: - Darwin / Xcode Support
#if os(OSX)
    private var O_SYNC: CInt { fatalError("Linux only") }
#endif
