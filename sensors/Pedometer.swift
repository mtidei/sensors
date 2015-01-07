//
//  Pedometer.swift
//  sensors
//
//  Created by Maurizio Tidei on 22/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import Foundation

class Pedometer {
    
    /// When was the threshold calculated the last time?
    var timestampThreshold:Double = 0
    
    /// The threshold we use to detect a step
    var workingThresholds = XYZStats()
    var nextThresholds = XYZStats()
    
    /// A small ring buffer with the last 4 values
    var xValues = NumericRing<Double>(capacity: 4)
    var yValues = NumericRing<Double>(capacity: 4)
    var zValues = NumericRing<Double>(capacity: 4)
    
    var steps = 0
    
    var xOld = 0.0
    var yOld = 0.0
    var zOld = 0.0
    
    // The timestamp of the last counted step
    var timestampLastStep:Double = 0
    
    
    /** Add a new accelerometer value for all axis
        :returns: true if new thresholds were calculated
    */
    func addAccelerometerValues(timestamp: Double, var x: Double, var y: Double, var z: Double) -> (thresholdUpdated:Bool, x:Double, y:Double, z:Double, steps:Int) {
        
        xValues.add(x)
        yValues.add(y)
        zValues.add(z)
        
        if(xValues.count < 4) {
            logInfo("Initializing Pedometer")
            return (thresholdUpdated:false, x:0, y:0, z:0, steps:steps)
        }
        
        x = xValues.average()
        y = yValues.average()
        z = zValues.average()
        
        // collect max and min data per axis
        for (newValue, savedValue) in [(x,nextThresholds.x), (y,nextThresholds.y), (z,nextThresholds.z)] {
            
            if newValue > savedValue.max {
                savedValue.max = newValue
            }
            if newValue < savedValue.min {
                savedValue.min = newValue
            }
        }
        
        // check if the threshold was passed from above
        //for (newValue, oldValue) in [(x, xOld), (y, yOld), (z, z)] {
        for (newValue, oldValue, stats) in [(x, xOld, workingThresholds.x)] {
            if newValue < stats.threshold && oldValue >= stats.threshold {
                
                // check if the time passed since the last step is in a reasonable time window
                if timestamp - timestampLastStep > 0.2 {
                    
                    // check if the amplitude is in a reasonable area
                    if (stats.max - stats.min) > 0.1 {
                        steps++
                        timestampLastStep = timestamp
                    }
                }
            }
        }
        
        xOld = x
        
        
        // init timestampThreshold if needed
        if timestampThreshold == 0 {
            timestampThreshold = timestamp
        }
        
        // check if it's time to update our threshold
        if(timestamp - timestampThreshold > 1) {
            
            // Swap working and next thresholds
            let tmpThreshold = workingThresholds
            workingThresholds = nextThresholds
            
            tmpThreshold.reset()
            nextThresholds = tmpThreshold
            
            // calc thresholds
            workingThresholds.x.threshold = (workingThresholds.x.min + workingThresholds.x.max) / 2
            workingThresholds.y.threshold = (workingThresholds.y.min + workingThresholds.y.max) / 2
            workingThresholds.z.threshold = (workingThresholds.z.min + workingThresholds.z.max) / 2
            
            timestampThreshold = timestamp
            
            logInfo(workingThresholds.description)
            
            return (thresholdUpdated:true, x:x, y:y, z:z, steps:steps)
        }
        
        return (thresholdUpdated:false, x:x, y:y, z:z, steps:steps)
    }
}


class XYZStats {
    
    var x = AxisStats()
    var y = AxisStats()
    var z = AxisStats()
    
    var description:String {
        get {
            
            var desc = ""
            
            for (name,axis) in ["x":x, "y":y, "z":z] {
                desc += "\(name)(min:\(axis.min) max:\(axis.max) threshold:\(axis.threshold))\n"
            }
            
            return desc
        }
    }
    
    func reset() {
        
        for axis in [x, y, z] {
            axis.min = 100
            axis.max = -100
            axis.threshold = 0
        }
    }
    
}


class AxisStats {
    
    var min = 100.0
    var max = -100.0
    var threshold = 0.0
}

