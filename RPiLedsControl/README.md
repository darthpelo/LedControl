<p>
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux-only" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>


# Web APIs

To realize the simple web APIs service for the project, I used [Vapor](https://vapor.codes/).

## 📖 Documentation

Officially there's not any documentation about Vapor ARM support, but after followed the [instructions](http://dev.iachieved.it/iachievedit/swift-3-0-on-raspberry-pi-2-and-3/) to install Swift 3 on a Raspberry Pi 2/3, you can use the Vapor [documentation](https://vapor.github.io/documentation/getting-started/install-toolbox.html) and install it on your Raspberry, also with Ubuntu 16.04.

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package and others information.

## 💻 Code

This web service manages two things:

1. handles web requests and return a JSON if a request succeed
2. controls the Raspberry Pi GPIOs

Everything happen inside the **main.swift** file in `/Sources/App/`.

### 1. Web Service

The server-side it's developed in `main.swift` using a Vapor template. For this first version I decided to use a simple *Routing Parameters* solution, to send the commands to turn on/off the led: `drop.get("cmd", ":id")`.

The route matches `/cmd/:id` where `:id` is an Int and `/status`.

For each valid `cmd` get, the API returns a JSON with the `:id` and the status (on/off) of the two led connected to the Raspberry Pi.

Same JSON result with the `status` request, but in this case no change to the led status.

So, how to switch on the led connected to BCM 20? Simple:
`http://hostname:port/cmd/1`.
This is the response:
`{"command":"1","green":"1","version":"1.0.0","yellow":"1"}`

```swift
let drop = Droplet()

let service = GPIOService.sharedInstance
service.setup()

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
```

### 2. 🚥 GPIO
To control the Raspberry GPIO I used the open source [SwiftGPIOLibrary](https://github.com/darthpelo/SwiftGPIOLibrary) and created a `GPIOService` class in `GPIOService.swift`:

```swift
final class GPIOService {
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
        throw GPIOError.InternalError
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
```

## 🌍 Web service configuration

For the purpose of this demo I configured only the development environment in `Config/development/server.json`:
```json
{
	"http": {
		"port": "$PORT:49152",
		"host": "192.168.192.16",
		"securityLayer": "none"
	}
}
```

## 🚀 Build & Run

As any other Vapor template, execute `vapor build` in the root folder of the project to build it.

To run the server using the port 80, at the moment, it is necessary to run first `sudo -i`, go to the project folder and execute `vapor run`.
If you want to use a another port, for example to run the service on your private network, you can use `sudo vapor run`. It's still necessary to run Vapor with root privilege to pilot the Raspberry GPIO.
