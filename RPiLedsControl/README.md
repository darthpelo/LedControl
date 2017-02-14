<p>
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux-only" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

# Web APIs

To realize the simple web APIs service for the project, I used [Vapor](https://vapor.codes/).

## 📖 Documentation

Officialy there's not any documentation about Vapor ARM support, but after followed the [istructions](http://dev.iachieved.it/iachievedit/swift-3-0-on-raspberry-pi-2-and-3/) to install Swift 3 on a Raspbbery Pi 2/3, you can use the Vapor [documentation](https://vapor.github.io/documentation/getting-started/install-toolbox.html) and install it on your Rasbbery, also with Ubuntu 16.04.

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package and others information.

## 💻 Code

This web service manages two things:

1. handles web requests and return a JSON if a request succeded
2. controls the Rasbbery Pi GPIOs

Everything happen inside the **main.swift** file in `/Sources/App/`.

### 1. Web Service

A simple web service with Vapor. For this firt version I decided to use a simple *Routing Parameters* solution, to send the commands to turn on/off the leds: `drop.get("cmd", ":id")`.

The route matches `/cmd/:id` where `:id` is an Int.

For each valid get, the API returns a JSON with the `:id` and the status (on/off) of the two leds connected to the Raspberry Pi.

```swift
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

    switch(cmdId) {
    case Command.Zero.rawValue:
        powerOff()
    case Command.One.rawValue:
        yellow()
    case Command.Two.rawValue:
        green()
    default:
        throw Abort.badRequest
    }

    return try JSON(node: [
        "version": "1.0.0",
        "command": "\(cmdId)",
        "yellow": "\(status(ports[.P20]))",
        "green": "\(status(ports[.P26]))"
        ])
}

drop.resource("posts", PostController())

drop.run()
```

### 2. GPIO
To control the Raspberry GPIO I used the open source [SwiftGPIOLibrary](https://github.com/darthpelo/SwiftGPIOLibrary)

```swift
let gpioLib = GPIOLib.sharedInstance
// Setup pin 20 and 26 as output with value 0
let list: [GPIOName] = [.P20, .P26]
let ports = gpioLib.setupOUT(ports: list, for: .RaspberryPi2)

func status(_ port: GPIO?) -> Int {
    guard let port = port else {
        return 0
    }

    return port.value
}

func yellow() {
    if (status(ports[.P20]) == 0) {
        gpioLib.switchOn(ports: [.P20])
    } else {
        gpioLib.switchOff(ports: [.P20])
    }
}

func green() {
    if (status(ports[.P26]) == 0) {
        gpioLib.switchOn(ports: [.P26])
    } else {
        gpioLib.switchOff(ports: [.P26])
    }
}

func powerOff() {
    gpioLib.switchOff(ports: list)
}
```

## 🌍 Web service configuration

For the purpose of this demo I configured only the development enviroment in `Config/development/server.json`:
```json
{
	"http": {
		"port": "$PORT:80",
		"host": "192.168.192.16",
		"securityLayer": "none"
	}
}
```

## 🚀 Build & Run

As any other Vapor template, execute `vapor build` in the root folder of the project to build it.

To run the server using the port 80, at the moment, it is necessary to run first `sudo -i`, go to the project folder and execute `vapor run`.
If you want to use a another port, for example to run the service on your private network, you can use `sudo vapor run`. It's still necessary to run Vapor with root privilege to pilot the Raspberry GPIO.

## ⌨️ Commands

So, how to switch on the led connected to BCM 20? Simple:
`http://hostname:port/cmd/1`.

A simple get, defined with this function:
```swift
drop.get("cmd", ":id") { request in
    guard let cmdId = request.parameters["id"]?.int else {
        throw Abort.badRequest
    }

    switch(cmdId) {
    case Command.Zero.rawValue:
        powerOff()
    case Command.One.rawValue:
        yellow()
    case Command.Two.rawValue:
        green()
    default:
        throw Abort.badRequest
    }

    return try JSON(node: [
        "version": "1.0.0",
        "command": "\(cmdId)",
        "yellow": "\(status(ports[.P20]))",
        "green": "\(status(ports[.P26]))"
        ])
}
```
The JSON in response gives you information about the leds status.
