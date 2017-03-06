#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import Vapor

func returnJson() -> ResponseRepresentable {
  return try JSON(node: [
      "version": "1.0.4"
      ])
}
// MARK: - Darwin / Xcode Support
#if os(OSX)
    private var O_SYNC: CInt { fatalError("Linux only") }
#endif
