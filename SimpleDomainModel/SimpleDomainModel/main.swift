//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String

    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }

    public func convert(_ to: String) -> Money {
        if (currencyCheck(to)) {
            var newAmount = self.amount
            let oldCurr = currency
            switch oldCurr {
            case "GBP":
                newAmount *= 2
            case "EUR":
                newAmount *= 2
                newAmount /= 3
            case "CAN":
                newAmount *= 4
                newAmount /= 5
            default:
                newAmount *= 1
            }
            switch to {
            case "GBP":
                newAmount /= 2
            case "EUR":
                newAmount /= 2
                newAmount *= 3
            case "CAN":
                newAmount /= 4
                newAmount *= 5
            default:
                newAmount *= 1
            }
            return Money(amount: newAmount, currency: to)
        }
        return self
    }
  
    public func add(_ to: Money) -> Money {
        if (currencyCheck(to.currency)) {
            let prev = convert(to.currency)
            return Money(amount: prev.amount + to.amount, currency: to.currency)
        }
        return to
    }
    public func subtract(_ from: Money) -> Money {
        if (currencyCheck(from.currency)) {
            let prev = convert(from.currency)
            return Money(amount: from.amount - prev.amount, currency: from.currency)
        }
        return from
    }
    
    private func currencyCheck(_ to: String) -> Bool {
        if (to == "GBP" || to == "EUR" || to == "USD" || to == "CAN") {
            return true;
        }
        return false;
    }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title // here
    self.type = type // here
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    return 0 // here
  }
  
  open func raise(_ amt : Double) {
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return nil } // here
    set(value) {
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return nil } // here
    set(value) {
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "1" // here
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
  }
  
  open func haveChild(_ child: Person) -> Bool {
    return false // here
  }
  
  open func householdIncome() -> Int {
    return 1 // here
  }
}





