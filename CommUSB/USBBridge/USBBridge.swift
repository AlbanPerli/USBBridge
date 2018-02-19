//
//  USBBridge.swift
//  CommUSB
//
//  Created by AL on 19/02/2018.
//  Copyright © 2018 Alban. All rights reserved.
//

import Foundation

class USBBridge:NSObject,PTChannelDelegate {
    
    static let shared = USBBridge()
    
    var serverChannel:PTChannel!
    var peerChannel:PTChannel!
    
    var receivedCallBack:((String)->())? = nil
    
    var isConnected:Bool = false
    
    func disconnect() {
        serverChannel.close()
    }
    
    func connect(_ callback:@escaping ()->()) {
        let channel = PTChannel(delegate: self)
        channel?.listen(onPort: in_port_t(PTExampleProtocolIPv4PortNumber), iPv4Address: INADDR_LOOPBACK, callback: { (err) in
            if (err != nil) {
                self.appendOutputMessage(message: "Failed to listen on 127.0.0.1:%d: %@")
            } else {
                self.appendOutputMessage(message: "Listening on 127.0.0.1:%d")
                self.serverChannel = channel;
                self.isConnected = true
                callback()
            }
            
        })
        
    }
    
    func send(_ message:String, callBack:@escaping (Error?)->()) {
        if peerChannel != nil {
            
            let payload = PTExampleTextDispatchDataWithString(message)
            peerChannel.sendFrame(ofType: UInt32(PTExampleFrameTypeTextMessage), tag: UInt32(PTFrameNoTag), withPayload: payload, callback: { (err) in
                callBack(err)
            })
        }else{
            callBack(NSError(domain: "Peer not connected", code: 404, userInfo: nil) as Error)
        }
    }
    
    func receivedMessage(_ callBack:@escaping (String)->()) {
        
        self.receivedCallBack = callBack
        
    }
    
    func ioFrameChannel(_ channel: PTChannel!, didReceiveFrameOfType type: UInt32, tag: UInt32, payload: PTData!) {
        
        if type == PTExampleFrameTypeTextMessage {
            let size = sizeFromFrame(payload.data)
            if let data = textFromFrame(payload.data){
                let correctSize = NSSwapBigIntToHost(size)
                let d = Data(bytes: data, count: Int(correctSize))
                if let str = String(data: d, encoding: String.Encoding.utf8){
                    if let callBack = receivedCallBack {
                        callBack(str)
                    }

                }
            }
            
        }
        
    }
    
    func ioFrameChannel(_ channel: PTChannel!, didAcceptConnection otherChannel: PTChannel!, from address: PTAddress!) {
        
        if peerChannel != nil {
            peerChannel.cancel()
        }
        
        peerChannel = otherChannel
        peerChannel.userInfo = address
        
        self.appendOutputMessage(message: "Connected to \(address)")
    }
    
    func appendOutputMessage(message:String) {
        print(">> \(message)")
    }
    
    func ioFrameChannel(_ channel: PTChannel!, didEndWithError error: Error!) {
        isConnected = false
    }
}
