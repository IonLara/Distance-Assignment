//
//  main.swift
//  Distance
//
//  Created by Ion Sebastian Rodriguez Lara on 13/03/23.
//

import Foundation

print("=================== Testing 1 ======================")
if let t = Distance() {
  print(t)
}
if let s = Distance(inches: 1234) {
  print(s)
}
if let r = Distance(inches: -123) {
  print(r)
}
if let d = Distance(inches: 1234567) {
  print(d)
}
if let x = Distance(miles: 1, yards: 3, feet: 2, inches: 7) {
  print(x)
}
if let y = Distance(miles: 2, yards: -4, feet: 6, inches: 8) {
  print(y)
}
if let z = Distance(miles: 3, yards: 5, feet: 7, inches: 9) {
  print(z)
}

print("=================== Testing 2 ======================")
let t = Distance(miles: 3, yards: 7, feet: 1, inches: 9)!
let s = Distance(miles: 2, yards: 6, feet: 0, inches: 8)!
let r = Distance(miles: 1, yards: 6, feet: 0, inches: 9)!
let d = Distance(miles: 2, yards: 5, feet: 2, inches: 7)!
print(t + s)
if let result = t - s {
  print(result)
} else {
  print("nil")
}
print(r + d)
if let result = r - d {
  print(result)
} else {
  print("nil")
}

let distances = [t, s, r, d]
print(distances.sorted(by: <))
print(distances.sorted(by: >))

print("=================== Testing 3 ======================")
let d1 = Distance(miles: 1, yards: 500, feet: 2, inches: 5)!
print(d1 * 3)
print(d1 * 5)
print(d1 * 0)

d1 += 3
print(d1)
d1 += 5
print(d1)
d1 += 1_000_000_000
print(d1)

