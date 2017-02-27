#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import SwiftyGPIO
import SwiftGPIOLibrary

final class GPIOService {
  private let gpioLib = GPIOLib.sharedInstance

  private var ports: [GPIOName: GPIO]
  private let list: [GPIOName] = [.P20, .P26]

  init() {
      self.ports = gpioLib.setupOUT(ports: [.P20, .P26], for: .RaspberryPi2)
  }

  var yellow: Int {
    return gpioLib.status(ports[.P20])
  }

  var green: Int {
    return gpioLib.status(ports[.P26])
  }

  func switchYellow(_ cmd: Int) {
      switch cmd {
      case Command.One:
          gpioLib.switchOn(ports: [.P20])
      case Command.Two:
          gpioLib.switchOff(ports: [.P20])
      default:()
      }
  }

  func switchGreen(_ cmd: Int) {
    switch cmd {
    case Command.Three:
        gpioLib.switchOn(ports: [.P26])
    case Command.Four:
        gpioLib.switchOff(ports: [.P26])
    default:()
    }
  }

  func powerOff() {
      gpioLib.switchOff(ports: list)
  }
}
