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

```swift

```
