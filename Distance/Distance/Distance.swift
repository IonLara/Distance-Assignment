//
//  Distance.swift
//  Distance
//
//  Created by Ion Sebastian Rodriguez Lara on 13/03/23.
//

import Foundation

class Distance: CustomStringConvertible, Comparable{
    private(set) var miles: Int
    private(set) var yards: Int
    private(set) var feet: Int
    private(set)var inches: Int
    
    //Constants for ease of checking----
    private static let MAXYARDS = 1760
    private static let MAXFEET = 3
    private static let MAXINCHES = 12
    //----------------------------------
    var description: String {
        //Print 0 inches if the distance = 0
        if miles == 0 && yards == 0 && feet == 0 && inches == 0 {
            return "(0\")"
        }
        //Check which variables are greater than 0 to display them
        let m = miles > 0 ? "\(miles)m " : ""
        let y = yards > 0 ? "\(yards)y " : ""
        let f = feet > 0 ? "\(feet)' " : ""
        let i = inches > 0 ? "\(inches)\"" : ""
        return "(\(m)\(y)\(f)\(i))"
    }

    //Function to simplify and convert the units from a distance instance by taking advantage of code in initializer
    private static func simplify(_ distance: Distance) -> Distance {
        //Unwrap the new distance
        if let sim = Distance(miles: distance.miles, yards: distance.yards, feet: distance.feet, inches: distance.inches) {
            return sim
        } else { //If invalid return a distance of 0
            return Distance()!
        }
    }
    //Adding two distances together
    static func +(lhs: Distance, rhs: Distance) -> Distance {
        if let answer = Distance(miles: lhs.miles + rhs.miles, yards: lhs.yards + rhs.yards, feet: lhs.feet + rhs.feet, inches: lhs.inches + rhs.inches) {
            return answer
        }
        return Distance()!
    }
    //Substracting two distances
    static func -(lhs: Distance, rhs: Distance) -> Distance? {
        if lhs.miles >= rhs.miles { //Check that the first distance is not smaller than the second one
            //Variables in order to do the substraction of values in case one of the variables from second distance is larger than its counterpart
            var m = lhs.miles //The value being subtracted
            var subM = rhs.miles //How much we substract
            var y = lhs.yards //The value being subtracted
            var subY = rhs.yards //How much we substract
            var f = lhs.feet //The value being subtracted
            var subF = rhs.feet //How much we substract
            var i = lhs.inches //The value being subtracted
            var subI = rhs.inches //How much we substract
            
            //Do the operations to get any extra substraction from the feet
            while subI > 0 { //While there are still inches to substract
                if subI > i { //If we substract more than we have
                    subF += 1 //We substract more from the next bigger unit
                    subI -= i
                    i = MAXINCHES //Set value at max to keep substracting
                } else { //If we can substract enough we just reduce the numbers
                    i -= subI //Substract the value
                    subI = 0
                }
            }
            //Repeat the steps above for the different units
            while subF > 0 {
                if subF > f {
                    subY += 1
                    subF -= f
                    f = MAXFEET
                } else {
                    f -= subF
                    subF = 0
                }
            }
            //Repeat the steps above for the different units
            while subY > 0 {
                if subY > y {
                    subM += 1
                    subY -= y
                    y = MAXYARDS
                } else {
                    y -= subY
                    subY = 0
                }
            }
            
            m -= subM //Set the value of the miles
            if let answer = Distance(miles: m, yards: y, feet: f, inches: i) { //Unwrap the new distance and make sure its formatted
                return answer
            } else {
                return Distance()!
            }
        } else { //If first distance is smaller than second return nil
            return nil
        }
    }
    //Metjod to multiply a distance by an Int
    static func *(lhs: Distance, rhs: Int) -> Distance {
        if let answer = Distance(miles: lhs.miles * rhs, yards: lhs.yards * rhs, feet: lhs.feet * rhs, inches: lhs.inches * rhs) {
            return answer
        }
        return Distance()!
    }
    //Method to add inches to distance
    static func +=(lhs:Distance, rhs: Int) {
        lhs.inches = lhs.inches + rhs //Add the inches
        let sim = Distance.simplify(lhs) //Reformat the values
        //Set the new values to the instance
        lhs.inches = sim.inches
        lhs.feet = sim.feet
        lhs.yards = sim.yards
        lhs.miles = sim.miles
    }
    //Compare if smaller
    static func <(lhs: Distance, rhs: Distance) -> Bool {
        if lhs.miles < rhs.miles { //If miles are smaller it will always be smaller
            return true
        } else if lhs.miles > rhs.miles { //If miles are larger it will always be larger
            return false
        }
        //If it's not smaller or larger then it's equal and we continue to next unit
        if lhs.yards < rhs.yards { //If yards are smaller...
            return true
        } else if lhs.yards > rhs.yards { //If yards are larger...
            return false
        }
        //If it's not smaller or larger then it's equal and we continue to next unit
        if lhs.feet < rhs.feet { //If feet are smaller...
            return true
        } else if lhs.feet > rhs.feet { //If feet are larger...
            return false
        }
        //If it's not smaller or larger then it's equal and we continue to next unit
        if lhs.inches < rhs.inches { //If inches are smaller...
            return true
        } else { //If this last unit is not smaller then the distance is not smaller
            return false
        }
    }
    //Method to compare if equal
    static func ==(lhs: Distance, rhs: Distance) -> Bool {
        lhs.miles == rhs.miles && lhs.yards == rhs.yards && lhs.feet == rhs.feet && lhs.inches == rhs.inches
    }
    
    //Failable initializer for distance 0
    init?() {
        miles = 0
        yards = 0
        feet = 0
        inches = 0
    }
    //Faileble initializer providing only inches
    init?(inches: Int) {
        if inches >= 0 { //If inches are a positive number then format and calculate
            
            if inches >= Distance.MAXINCHES { //If we have more inches than one foot
                self.inches = inches % Distance.MAXINCHES //Set inches as the remainder
                feet = inches / Distance.MAXINCHES //Get the number of extra feet
                
                if feet >= Distance.MAXFEET { //If we have more feet than one yard
                    yards = feet / Distance.MAXFEET //Get the number of extra yards
                    feet = feet % Distance.MAXFEET //Set the feet as the remainder
                    
                    if yards >= Distance.MAXYARDS { //If we have more yards than a mile
                        miles = yards / Distance.MAXYARDS //Get number of miles
                        yards = yards % Distance.MAXYARDS //Set the yards as the remainder
                    } else { //If we didn't complete any miles
                        miles = 0
                    }
                } else { //If we didn't complete any yards
                    yards = 0
                    miles = 0
                }
            } else {  //If we didn't complete any feet
                self.inches = inches
                miles = 0
                yards = 0
                feet = 0
            }
        } else { //If inches is a negative number then return nil
            return nil
        }
    }
    //Failable Initializer requiring all the parameters
    init?(miles: Int, yards: Int, feet: Int, inches: Int) {
        //Check that all values are positive numbers
        if miles >= 0 && yards >= 0 && feet >= 0 && inches >= 0 {
            var extraMiles = 0 //Extra miles added by yards
            var extraYards = 0 //Extra yards added by feet
            var extraFeet = 0 //Extra feet added by inches
            
            if inches >= Distance.MAXINCHES { //If we have more inches than a foot
                extraFeet = inches / Distance.MAXINCHES //Get the extra to add to feet
                self.inches = inches % Distance.MAXINCHES //Set remainder as inches
            } else {
                self.inches = inches //If we don't have extra just set inches as given number
            }
            //Repeat steps above for the next tiers of units-----------
            if feet + extraFeet >= Distance.MAXFEET {
                extraYards = (feet + extraFeet) / Distance.MAXFEET
                self.feet = (feet + extraFeet)  % Distance.MAXFEET
            } else {
                self.feet = feet + extraFeet //If we don't have extra just set feet as given number
            }
            if yards + extraYards >= Distance.MAXYARDS {
                extraMiles = (yards + extraYards) / Distance.MAXYARDS
                self.yards = (yards + extraYards) % Distance.MAXYARDS
            } else {
                self.yards = yards + extraYards //If we don't have extra just set yards as given number
            }
            //----------------------------------------------------------
            self.miles = miles + extraMiles //Add any extra miles we had
        } else { //If there's any negative numbers then return nil
            return nil
        }
    }
}
