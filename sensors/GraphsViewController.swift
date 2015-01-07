//
//  GraphsViewController.swift
//  sensors
//
//  Created by Maurizio Tidei on 13/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import UIKit
import CoreMotion

class GraphsViewController: UIViewController {

    
    var motionManager = CMMotionManager()
    
    var paused = false
    
    var userAccelerationMeasurements = [(Double, CMAcceleration)]()
    let lockQueue = dispatch_queue_create("userAccelerationMeasurementsArrayLock", nil)
    
    var numberOfRecords = 0
    
    @IBOutlet weak var accelerationXView: GraphView!
    
    @IBOutlet weak var accelerationYView: GraphView!
    
    var pedometer = Pedometer()
    
    @IBOutlet weak var stepsLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var operationQueue = NSOperationQueue()
        operationQueue.name = "DeviceMotionQueue2"
        
        let referenceFrame = motionManager.attitudeReferenceFrame.value
        logInfo("Reference Frame: \(referenceFrame)")
        
        //motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXTrueNorthZVertical, toQueue: operationQueue, withHandler: {
        //(deviceMotion:CMDeviceMotion!, error:NSError!) in
                
        motionManager.startAccelerometerUpdatesToQueue(operationQueue, withHandler: {
            (deviceMotion:CMAccelerometerData!, error:NSError!) in
        
            
            if !self.paused {
                
                if error != nil {
                    logError(error.localizedDescription)
                }
                else {
                    
                    dispatch_sync(self.lockQueue) {
                       
                        //self.userAccelerationMeasurements.append((deviceMotion.timestamp, deviceMotion.userAcceleration))
                        //logInfo("userAccelerationMeasurements.count: \(self.userAccelerationMeasurements.count)")
                        
                        let result = self.pedometer.addAccelerometerValues(deviceMotion.timestamp, x: deviceMotion.acceleration.x, y: deviceMotion.acceleration.y, z: deviceMotion.acceleration.z)
                        
                        if result.thresholdUpdated {
                            
                            self.accelerationXView.min = self.pedometer.workingThresholds.x.min
                            self.accelerationXView.max = self.pedometer.workingThresholds.x.max
                            self.accelerationXView.threshold = self.pedometer.workingThresholds.x.threshold
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.accelerationXView.addValue(x: deviceMotion.timestamp, y: result.x)
                            self.accelerationYView.addValue(x: deviceMotion.timestamp, y: result.y)
                            
                            self.stepsLabel.text = String(result.steps)
                        })
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

