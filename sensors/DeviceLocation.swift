//
//  DeviceLocation.swift
//  sensors
//
//  Created by Maurizio Tidei on 14/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import Foundation
import CoreMotion

class DeviceLocation {
    
    var speed = Vector3()
    var location = Vector3()
    
    var zeroAccelerationCount = 0
    
    func update(seconds: Double, acceleration: Vector3) {
        
        if acceleration.x + acceleration.y + acceleration.z < 0.02 {
            
            zeroAccelerationCount++
        }
        
        if false && zeroAccelerationCount == 20 {
            
            speed.x = 0
            speed.y = 0
            speed.z = 0
            
            zeroAccelerationCount = 0
        }
        else {
            
            acceleration.x = round(acceleration.x * 100) / 100
            acceleration.y = round(acceleration.y * 100) / 100
            acceleration.z = round(acceleration.z * 100) / 100
            
            speed.x = speed.x + seconds * acceleration.x
            speed.y = speed.y + seconds * acceleration.y
            speed.z = speed.z + seconds * acceleration.z
            
            location.x = location.x + seconds * speed.x
            location.y = location.y + seconds * speed.y
            location.z = location.z + seconds * speed.z
        }
    }
}


class Vector3 {
    
    var x: Double
    var y: Double
    var z: Double
    
    init() {
        
        x = 0
        y = 0
        z = 0
    }
    
    init(x:Double, y:Double, z:Double) {
        
        self.x = x
        self.y = y
        self.z = z
    }
}


extension CMAcceleration {
    
    func toVector3() -> Vector3 {
        
        return Vector3(x: x * 9.81, y: y * 9.81, z: z * 9.81)
    }
}