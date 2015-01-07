//
//  FirstViewController.swift
//  sensors
//
//  Created by Maurizio Tidei on 13/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import UIKit
import CoreMotion

class FirstViewController: UIViewController {

    @IBOutlet weak var logField: UITextView!
    
    var motionManager = CMMotionManager()
    
    // Gravity
    @IBOutlet weak var gravityXLabel: UILabel!
    @IBOutlet weak var gravityYLabel: UILabel!
    @IBOutlet weak var gravityZLabel: UILabel!
    
    @IBOutlet weak var gravityRangeXLabel: UILabel!
    @IBOutlet weak var gravityRangeYLabel: UILabel!
    @IBOutlet weak var gravityRangeZLabel: UILabel!
    
    // User Acceleration
    @IBOutlet weak var userAccXLabel: UILabel!
    @IBOutlet weak var userAccYLabel: UILabel!
    @IBOutlet weak var userAccZLabel: UILabel!
    
    @IBOutlet weak var userAccRangeXLabel: UILabel!
    @IBOutlet weak var userAccRangeYLabel: UILabel!
    @IBOutlet weak var userAccRangeZLabel: UILabel!
    
    // Attitude
    @IBOutlet weak var attitudeXLabel: UILabel!
    @IBOutlet weak var attitudeYLabel: UILabel!
    @IBOutlet weak var attitudeZLabel: UILabel!
    
    @IBOutlet weak var attitudeRangeXLabel: UILabel!
    @IBOutlet weak var attitudeRangeYLabel: UILabel!
    @IBOutlet weak var attitudeRangeZLabel: UILabel!
    
    // Rotation Rate
    @IBOutlet weak var rotationRateXLabel: UILabel!
    @IBOutlet weak var rotationRateYLabel: UILabel!
    @IBOutlet weak var rotationRateZLabel: UILabel!
    
    @IBOutlet weak var rotationRateRangeXLabel: UILabel!
    @IBOutlet weak var rotationRateRangeYLabel: UILabel!
    @IBOutlet weak var rotationRateRangeZLabel: UILabel!
    
    // Magnetic Field
    @IBOutlet weak var magneticFieldXLabel: UILabel!
    @IBOutlet weak var magneticFieldYLabel: UILabel!
    @IBOutlet weak var magneticFieldZLabel: UILabel!
    
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    var paused = false
    
    var ranges = SensorRanges()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        logInfo("View did Load")
        
        var operationQueue = NSOperationQueue()
        operationQueue.name = "DeviceMotionQueue"
        
        let referenceFrame = motionManager.attitudeReferenceFrame.value
        logInfo("Reference Frame: \(referenceFrame)")
        
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrameXTrueNorthZVertical, toQueue: operationQueue, withHandler: {
            
            (deviceMotion:CMDeviceMotion!, error:NSError!) in
            
            if !self.paused {
                
                if error != nil {
                    logError(error.localizedDescription)
                }
                else {
                
                    let gravity         = deviceMotion.gravity
                    let userAcc         = deviceMotion.userAcceleration
                    let rotationRate    = deviceMotion.rotationRate
                    let attitude        = deviceMotion.attitude
                    let magnetic        = deviceMotion.magneticField
                    
                    self.ranges.processNewGravity(gravity)
                    self.ranges.processNewUserAcceleration(userAcc)
                    //self.ranges.processNewAttitude(attitude)
                    
                    //logInfo("x:" + deviceMotion.graacceleration.x.description + " \ty:" + deviceMotion.acceleration.y.description  + " \tz:" + deviceMotion.acceleration.z.description )
                    
                    // Update UI
                    dispatch_async( dispatch_get_main_queue()) {
                        
                        self.gravityXLabel.text = String(format: "%2.4f", gravity.x)
                        self.gravityYLabel.text = String(format: "%2.4f", gravity.y)
                        self.gravityZLabel.text = String(format: "%2.4f", gravity.z)
                        
                        self.gravityRangeXLabel.text = String(format: "%2.2f ... %2.2f", self.ranges.gravity.min.x, self.ranges.gravity.max.x)
                        self.gravityRangeYLabel.text = String(format: "%2.2f ... %2.2f", self.ranges.gravity.min.y, self.ranges.gravity.max.y)
                        self.gravityRangeZLabel.text = String(format: "%2.2f ... %2.2f", self.ranges.gravity.min.z, self.ranges.gravity.max.z)
                        
                        self.userAccXLabel.text = String(format: "%2.4f", userAcc.x)
                        self.userAccYLabel.text = String(format: "%2.4f", userAcc.y)
                        self.userAccZLabel.text = String(format: "%2.4f", userAcc.z)
                        
                        self.userAccRangeXLabel.text = String(format: "%2.2f ... %2.2f", self.ranges.userAcc.min.x, self.ranges.userAcc.max.x)
                        self.userAccRangeYLabel.text = String(format: "%2.2f ... %2.2f", self.ranges.userAcc.min.y, self.ranges.userAcc.max.y)
                        self.userAccRangeZLabel.text = String(format: "%2.2f ... %2.2f", self.ranges.userAcc.min.z, self.ranges.userAcc.max.z)
                        
                        self.attitudeXLabel.text = String(format: "%2.4f", attitude.pitch)
                        self.attitudeYLabel.text = String(format: "%2.4f", attitude.roll)
                        self.attitudeZLabel.text = String(format: "%2.4f", attitude.yaw)
                        
                        // TODO: Attitude Range
                        
                        self.rotationRateXLabel.text = String(format: "%2.4f", rotationRate.x)
                        self.rotationRateYLabel.text = String(format: "%2.4f", rotationRate.y)
                        self.rotationRateZLabel.text = String(format: "%2.4f", rotationRate.z)
                        
                        // TODO: Rotation Rate Range
                        
                        self.magneticFieldXLabel.text = String(format: "%2.4f", magnetic.field.x)
                        self.magneticFieldYLabel.text = String(format: "%2.4f", magnetic.field.y)
                        self.magneticFieldZLabel.text = String(format: "%2.4f", magnetic.field.z)
                        
                        //logInfo("Accuracy \(magnetic.accuracy.value)")
                        
                        // TODO: MagneticField Range
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pausePressed(sender: UIBarButtonItem) {
        
        paused = true
        playButton.enabled = true
        pauseButton.enabled = false
    }
  
    @IBAction func playPressed(sender: UIBarButtonItem) {
        
        paused = false
        playButton.enabled = false
        pauseButton.enabled = true
    }
    
    @IBAction func resetRanges(sender: AnyObject) {
        
        ranges = SensorRanges()
    }
}

