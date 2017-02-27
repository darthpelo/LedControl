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

  func switchYellow() {
      print("switchYellow: \(gpioLib.status(ports[.P20]))")
      if (gpioLib.status(ports[.P20]) == 0) {
          gpioLib.switchOn(ports: [.P20])
      } else {
          gpioLib.switchOff(ports: [.P20])
      }
  }

  func switchGreen() {
      print("switchGreen: \(gpioLib.status(ports[.P26]))")
      if (gpioLib.status(ports[.P26]) == 0) {
          gpioLib.switchOn(ports: [.P26])
      } else {
          gpioLib.switchOff(ports: [.P26])
      }
  }

  func powerOff() {
      gpioLib.switchOff(ports: list)
  }
}
