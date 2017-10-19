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
// protocol
//
protocol Mathematics {
    static func +(to: Self, adding: Self) -> Self
    static func -(from: Self, subtracting: Self) -> Self
}

// extension
//
extension Double {
    var USD: Money { return Money(amount: self, currency: Money.CurrencyType.USD) }
    var EUR: Money { return Money(amount: self, currency: Money.CurrencyType.EUR) }
    var GBP: Money { return Money(amount: self, currency: Money.CurrencyType.GBP) }
    var CAN: Money { return Money(amount: self, currency: Money.CurrencyType.CAN) }
}

// Money
//
public struct Money: CustomStringConvertible, Mathematics {
    public var amount : Double
    public var currency : CurrencyType
    
    public enum CurrencyType {
        case GBP
        case EUR
        case CAN
        case USD
    }

    public func convert(_ to: CurrencyType) -> Money {
        if (currencyCheck(to)) {
            var newAmount = self.amount
            let oldCurr = currency
            switch oldCurr {
            case .GBP:
                newAmount *= 2
            case .EUR:
                newAmount *= 2
                newAmount /= 3
            case .CAN:
                newAmount *= 4
                newAmount /= 5
            default:
                newAmount *= 1
            }
            switch to {
            case .GBP:
                newAmount /= 2
            case .EUR:
                newAmount /= 2
                newAmount *= 3
            case .CAN:
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
            return Money(amount: prev.amount - from.amount, currency: from.currency)
        }
        return from
    }
    
    private func currencyCheck(_ to: CurrencyType) -> Bool {
        if (to == .GBP || to == .EUR || to == .USD || to == .CAN) {
            return true;
        }
        return false;
    }
    
    public var description: String {
        return "\(self.currency)\(self.amount)"
    }
    
    static func +(to: Money, adding: Money) -> Money {
        return to.add(adding)
    }
    static func -(from: Money, subtracting: Money) -> Money {
        return from.subtract(subtracting)
    }
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible {
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
    
  public var description: String {
    switch type {
    case let .Salary(value):
      return "\(self.title) with a salary of \(value)"
    case let .Hourly(value):
      return "\(self.title) with an hourly wage of \(value)"
    }
  }
}

////////////////////////////////////
// Person
//
open class Person: CustomStringConvertible {
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
    
  public var description: String {
    return "\(self.firstName) \(self.lastName) (\(self.age) years old)"
  }
}

////////////////////////////////////
// Family
//
open class Family: CustomStringConvertible {
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
    
  public var description: String {
    var familyMembers = ""
    for each in self.members {
        familyMembers += each.description + ", "
    }
    let result = familyMembers.dropLast(2)
    return String(result)
  }
}





