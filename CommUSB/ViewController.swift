//
//  ViewController.swift
//  CommUSB
//
//  Created by AL on 19/02/2018.
//  Copyright © 2018 Alban. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var timer:Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        USBBridge.shared.connect {

        }
        
        USBBridge.shared.receivedMessage({ (str) in
            print("Received \(str)")
        })
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        USBBridge.shared.disconnect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonClicked(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (t) in
            if USBBridge.shared.isConnected {
                
                USBBridge.shared.send(Date().debugDescription) { (err) in
                    
                }
            }
        }
        
        
    }
    
   
    
    
}

