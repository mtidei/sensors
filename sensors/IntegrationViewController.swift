//
//  IntegrationViewController.swift
//  sensors
//
//  Created by Maurizio Tidei on 14/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import UIKit
import CoreMotion

class IntegrationViewController: UIViewController {
    
    @IBOutlet weak var accelerationX: UILabel!
    @IBOutlet weak var accelerationY: UILabel!
    @IBOutlet weak var accelerationZ: UILabel!
    
    @IBOutlet weak var velocityX: UILabel!
    @IBOutlet weak var velocityY: UILabel!
    @IBOutlet weak var velocityZ: UILabel!
    
    @IBOutlet weak var positionX: UILabel!
    @IBOutlet weak var positionY: UILabel!
    @IBOutlet weak var positionZ: UILabel!
    
    
    var motionManager = CMMotionManager()
    
    var paused = false
    
    var location = DeviceLocation()
    
    var lastTimestamp:NSTimeInterval? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var operationQueue = NSOperationQueue()
        operationQueue.name = "DeviceMotionQueue"
       
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXTrueNorthZVertical, toQueue: operationQueue, withHandler: {
            
            (deviceMotion:CMDeviceMotion!, error:NSError!) in
            
            if !self.paused {
                
                if error != nil {
                    logError(error.localizedDescription)
                }
                else {
                    
                    if self.lastTimestamp != nil {
                        let deltaTime = deviceMotion.timestamp - self.lastTimestamp!
                        self.location.update(deltaTime, acceleration: deviceMotion.userAcceleration.toVector3())
                        
                        // Update UI
                        dispatch_async( dispatch_get_main_queue()) {
                            
                            self.accelerationX.text = String(format: "%2.2f", deviceMotion.userAcceleration.x)
                            self.accelerationY.text = String(format: "%2.2f", deviceMotion.userAcceleration.y)
                            self.accelerationZ.text = String(format: "%2.2f", deviceMotion.userAcceleration.z)
                            
                            self.velocityX.text = String(format: "%2.2f", self.location.speed.x)
                            self.velocityY.text = String(format: "%2.2f", self.location.speed.y)
                            self.velocityZ.text = String(format: "%2.2f", self.location.speed.z)
                            
                            self.positionX.text = String(format: "%2.2f", self.location.location.x)
                            self.positionY.text = String(format: "%2.2f", self.location.location.y)
                            self.positionZ.text = String(format: "%2.2f", self.location.location.z)
                        }
                    }
                    
                    self.lastTimestamp = deviceMotion.timestamp
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}