//
//  SensorRanges.swift
//  sensors
//
//  Created by Maurizio Tidei on 14/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import Foundation
import CoreMotion

class SensorRanges {
    
    var gravity = MinMaxAcceleration()
    var userAcc = MinMaxAcceleration()
    
    
    func processNewGravity(newGravity:CMAcceleration) {
        
        processNewAcceleration(gravity, newValue: newGravity)
    }
    
    func processNewUserAcceleration(newUserAcc:CMAcceleration) {
        
        processNewAcceleration(userAcc, newValue: newUserAcc)
    }
    
    private func processNewAcceleration(ownValue:MinMaxAcceleration, newValue:CMAcceleration) {
        
        processSingleAxis(&ownValue.min.x, &ownValue.max.x, newValue.x)
        processSingleAxis(&ownValue.min.y, &ownValue.max.y, newValue.y)
        processSingleAxis(&ownValue.min.z, &ownValue.max.z, newValue.z)
    }
    
    private func processSingleAxis(inout storedMin:Double, inout _ storedMax:Double, _ newVal:Double) {
        
        if(storedMin > newVal) {
            storedMin = newVal
        }
        if(storedMax < newVal) {
            storedMax = newVal
        }
    }
    
}


class MinMaxAcceleration {
    
    var min = CMAcceleration(x:1, y:1, z:1)
    var max = CMAcceleration(x:-1, y:-1, z:-1)
}

enum Axis {
    case x
    case y
    case z
}