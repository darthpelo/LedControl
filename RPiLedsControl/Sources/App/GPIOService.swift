#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

// MARK: - Darwin / Xcode Support
#if os(OSX)
    private var O_SYNC: CInt { fatalError("Linux only") }
#endif

import SwiftyGPIO
import SwiftGPIOLibrary

enum Command {
    static let Zero = 0
    static let One = 1
    static let Two = 2
		static let Three = 3
		static let Four = 4
}

final class GPIOService {
  class var sharedInstance: GPIOService {
    struct Singleton {
      static let instance = GPIOService()
    }
    return Singleton.instance
  }

  private let gpioLib = GPIOLib.sharedInstance

  private var ports: [GPIOName: GPIO] = [:]
  private let list: [GPIOName] = [.P20, .P26]

  func setup() {
    self.ports = gpioLib.setupOUT(ports: [.P20, .P26], for: .RaspberryPi2)
  }

  var yellow: Int {
    return gpioLib.status(ports[.P20])
  }

  var green: Int {
    return gpioLib.status(ports[.P26])
  }

  func execute(command: Int) throws {
    switch(command) {
    case Command.Zero:
        powerOff()
    case Command.One:
        switchYellow(Command.One)
    case Command.Two:
        switchYellow(Command.Two)
    case Command.Three:
        switchGreen(Command.Three)
    case Command.Four:
        switchGreen(Command.Four)
    default:
        throw Abort.badRequest
    }
  }

  fileprivate func switchYellow(_ cmd: Int) {
    switch cmd {
    case Command.One:
      gpioLib.switchOn(ports: [.P20])
    case Command.Two:
      gpioLib.switchOff(ports: [.P20])
    default:()
    }
  }

  fileprivate func switchGreen(_ cmd: Int) {
    switch cmd {
    case Command.Three:
      gpioLib.switchOn(ports: [.P26])
    case Command.Four:
      gpioLib.switchOff(ports: [.P26])
    default:()
    }
  }

  fileprivate func powerOff() {
    gpioLib.switchOff(ports: list)
  }
}
