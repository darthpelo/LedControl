# Led Control
![Swift_Logo](http://eclipsesource.com/blogs/wp-content/uploads/2014/06/Apple_Swift_Logo.png)

A Swift 3.0 full stack project to control remotely led:

* iOS application,
* web service and I/O control on a Raspberry Pi.

Every part wrote in Swift.

## 🏆 Purpose

When in the summer of 2016 I discovered that some one started to deploy a Swift version for the Raspberry Pi 2/3, I decided to realize a real full stack project:
* A web service with Swift
* A iOS mobile application in Swift
* A software in Swift to control I/O on a Raspberry Pi

Finally I found the time to create a first simple Swift full stack project 😎

## 🔩 Components

### 1. 🤖 Hardware

Raspberry Pi 2, a demo board, wires and led.

![Raspberry](https://github.com/darthpelo/LedsControl/blob/master/Images/FullSizeRender.jpg)

### 2. 💡 Web Service and Leds control

RPiLedsControl [README](https://github.com/darthpelo/LedsControl/tree/develop/RPiLedsControl) using **Vapor**.

### 3. 📱 iOS application

[iOSLedsControl](https://github.com/darthpelo/LedsControl/tree/develop/iOSLedsControl)

### 4. 🌍 Public IP

An [easy & free](https://www.noip.com) service to make public the port 80 of your Raspberry PI. Remember that this is a simply demo, so I didn't implement any security... [be careful](http://www.welivesecurity.com/2016/10/24/10-things-know-october-21-iot-ddos-attacks/)!☠️

## ✨ Finalr Result

A [video](https://vimeo.com/202640110) that shows how I can turn on/off led with my iPad and an internet connection 😎
![Test](https://github.com/darthpelo/LedsControl/blob/develop/Images/test.gif)
