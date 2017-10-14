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
/*
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
*/
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
            let prev = self.convert(to.currency)
            return Money(amount: prev.amount + to.amount, currency: to.currency)
        }
        return to
    }
    public func subtract(_ from: Money) -> Money {
        if (currencyCheck(from.currency)) {
            let prev = self.convert(from.currency)
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
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case let .Salary(value):
        return value
    case let .Hourly(value):
        return Int(value * Double(hours))
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case let .Salary(value):
        self.type = JobType.Salary(value + Int(amt))
    case let .Hourly(value):
        self.type = JobType.Hourly(value + amt)
    }
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
    get { return _job }
    set(value) {
        if(self.age >= 16) {
            _job = Job(title: value!.title, type: value!.type)
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if(self.age >= 16) {
            _spouse = Person(firstName: value!.firstName, lastName: value!.lastName, age: value!.age)
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
    
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job)) spouse:\(String(describing: self.spouse))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) {
        self.members = [spouse1, spouse2]
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if (members[0].age >= 21 || members[1].age >= 21) {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var result = 0
    for person in members {
        if (person.job != nil) {
            result += person.job!.calculateIncome(2000)
        }
    }
    return result
  }
}





