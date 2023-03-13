//
//  Distance.swift
//  Distance
//
//  Created by Ion Sebastian Rodriguez Lara on 13/03/23.
//

import Foundation

class Distance: CustomStringConvertible, Comparable{
    var miles: Int
    var yards: Int
    var feet: Int
    var inches: Int
    
    private static let maxYards = 1760
    private static let maxFeet = 3
    private static let maxInches = 12
    
    var description: String {
        if miles == 0 && yards == 0 && feet == 0 && inches == 0 {
            return "(0\")"
        }
        let m = miles > 0 ? "\(miles)m " : ""
        let y = yards > 0 ? "\(yards)y " : ""
        let f = feet > 0 ? "\(feet)' " : ""
        let i = inches > 0 ? "\(inches)\"" : ""
        return "(\(m)\(y)\(f)\(i))"
    }
    
    private static func simplify(_ distance: Distance) -> Distance {
        var m = distance.miles
        var y = distance.yards
        var f = distance.feet
        var i = distance.inches
        
        if m >= 0 && y >= 0 && f >= 0 && i >= 0 {
            var extraMiles = 0
            var extraYards = 0
            var extraFeet = 0
            if i >= maxInches {
                extraFeet = i / maxInches
                i = i % maxInches
            }
            f = f + extraFeet
            if f >= maxFeet {
                extraYards = f / maxFeet
                f = f % maxFeet
            }
            y = y + extraYards
            if y >= maxYards {
                extraMiles = y / maxYards
                y = y % maxYards
            }
            m = m + extraMiles
        }
        if let sim = Distance(miles: m, yards: y, feet: f, inches: i) {
            return sim
        } else {
            return Distance()!
        }
    }
    
    static func +(lhs: Distance, rhs: Distance) -> Distance {
        if let answer = Distance(miles: lhs.miles + rhs.miles, yards: lhs.yards + rhs.yards, feet: lhs.feet + rhs.feet, inches: lhs.inches + rhs.inches) {
            return Distance.simplify(answer)
        }
        return Distance()!
    }
    
    static func -(lhs: Distance, rhs: Distance) -> Distance? {
        if let answer = Distance(miles: lhs.miles - rhs.miles, yards: lhs.yards - rhs.yards, feet: lhs.feet - rhs.feet, inches: lhs.inches - rhs.inches) {
            return Distance.simplify(answer)
        } else {
            return nil
        }
    }
    
    static func *(lhs: Distance, rhs: Int) -> Distance {
        if let answer = Distance(miles: lhs.miles * rhs, yards: lhs.yards * rhs, feet: lhs.feet * rhs, inches: lhs.inches * rhs) {
            return Distance.simplify(answer)
        }
        return Distance()!
    }
    
    static func +=(lhs:Distance, rhs: Int) {
        lhs.inches = lhs.inches + rhs
        let sim = Distance.simplify(lhs)
        lhs.inches = sim.inches
        lhs.feet = sim.feet
        lhs.yards = sim.yards
        lhs.miles = sim.miles
    }
    
    static func <(lhs: Distance, rhs: Distance) -> Bool {
        if lhs.miles < rhs.miles {
            return true
        } else if lhs.miles > rhs.miles {
            return false
        }
        if lhs.yards < rhs.yards {
            return true
        } else if lhs.yards > rhs.yards {
            return false
        }
        if lhs.feet < rhs.feet {
            return true
        } else if lhs.feet > rhs.feet {
            return false
        }
        if lhs.inches < rhs.inches {
            return true
        } else {
            return false
        }
    }
    
    static func ==(lhs: Distance, rhs: Distance) -> Bool {
        lhs.miles == rhs.miles && lhs.yards == rhs.yards && lhs.feet == rhs.feet && lhs.inches == rhs.inches
    }
    
    init?() {
        miles = 0
        yards = 0
        feet = 0
        inches = 0
    }
    
    init?(inches: Int) {
        if inches >= 0 {
            if inches >= Distance.maxInches {
                self.inches = inches % Distance.maxInches
                feet = inches / Distance.maxInches
                if feet >= Distance.maxFeet {
                    yards = feet / Distance.maxFeet
                    feet = feet % Distance.maxFeet
                    if yards >= Distance.maxYards {
                        miles = yards / Distance.maxYards
                        yards = yards % Distance.maxYards
                    } else {
                        miles = 0
                    }
                } else {
                    yards = 0
                    miles = 0
                }
            } else {
                self.inches = inches
                miles = 0
                yards = 0
                feet = 0
            }
        } else {
            return nil
        }
    }
    
    init?(miles: Int, yards: Int, feet: Int, inches: Int) {
        if miles >= 0 && yards >= 0 && feet >= 0 && inches >= 0 {
            var extraMiles = 0
            var extraYards = 0
            var extraFeet = 0
            if inches >= Distance.maxInches {
                extraFeet = inches / Distance.maxInches
                self.inches = inches % Distance.maxInches
            } else {
                self.inches = inches
            }
            if feet + extraFeet >= Distance.maxFeet {
                extraYards = (feet + extraFeet) / Distance.maxFeet
                self.feet = (feet + extraFeet)  % Distance.maxFeet
            } else {
                self.feet = feet + extraFeet
            }
            if yards + extraYards >= Distance.maxYards {
                extraMiles = (yards + extraYards) / Distance.maxYards
                self.yards = (yards + extraYards) % Distance.maxYards
            } else {
                self.yards = yards + extraYards
            }
            self.miles = miles + extraMiles
        } else {
            return nil
        }
    }
}
