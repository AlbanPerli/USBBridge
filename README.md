# USBBridge
Swift wrapper based on https://github.com/rsms/peertalk

Use the iOS device's USB port to communicate via TCP protocol 

### Mac Os server:
https://github.com/rsms/peertalk

### Python server
https://github.com/davidahouse/peertalk-python/blob/master/peertalk.py

See: https://makezine.com/2013/04/22/peertalk-beaglebone-and-raspberry-pi/

Communicate via USB:

## Connect to server via USB
```swift
 USBBridge.shared.connect {

 }
```

## Received Message via USB
```swift
USBBridge.shared.receivedMessage({ (str) in
   print("Received \(str)")
})
```

## Send Message via USB
```swift
USBBridge.shared.send("My Message") { (err) in
                
}
```

## Disconnect
```swift
USBBridge.shared.disconnect()
```


