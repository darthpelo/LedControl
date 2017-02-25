#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import SwiftyGPIO
import SwiftGPIOLibrary

final class GpioService {
  private let gpioLib = GPIOLib.sharedInstance
  // Setup pin 20 and 26 as output with value 0
  //private let ports = GPIOLib.sharedInstance.setupOUT(ports: [.P20, .P26], for: .RaspberryPi2)
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
      if (gpioLib.status(ports[.P20]) == 0) {
          gpioLib.switchOn(ports: [.P20])
      } else {
          gpioLib.switchOff(ports: [.P20])
      }
  }

  func switchGreen() {
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
