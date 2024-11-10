//
//  SpeedCalculations.swift
//  RunRhythm
//
//  Created by Raman Kozar on 10/11/2024.
//

class SpeedCalculations {
    
    // Getting maximum speed
    //
    func getMaximumSpeed(_ optionUnit: Int, _ scale: Int) -> Int {
        
        if optionUnit == 0 {
            
            switch scale {
            case 0:
                return 10
            case 1:
                return 15
            case 2:
                return 20
            default:
                return 25
            }
            
        } else if optionUnit == 1 {
            
            switch scale {
            case 0:
                return 3
            case 1:
                return 5
            case 2:
                return 7
            default:
                return 9
            }
            
        } else {
            
            switch scale {
            case 0:
                return 5
            case 1:
                return 8
            case 2:
                return 10
            default:
                return 13
            }
            
        }
        
    }

    // Getting converting speed
    //
    func getConvertSpeed(_ optionUnit: Int, _ speed /*m/s*/ : Double) -> Double {
        
        switch optionUnit {
        case 0:
            return speed * 3.6
        case 1:
            return speed
        default:
            return speed * 2.2369362921
        }
        
    }

    // Getting option unit
    //
    func getSpeedOptionUnit(_ unit: Int) -> String {
        
        switch unit {
        case 0:
            return "km/h"
        case 1:
            return "m/s"
        default:
            return "mph"
        }
        
    }
    
}
