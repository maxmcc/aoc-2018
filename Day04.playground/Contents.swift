import Foundation

let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
let inputString = try! String(contentsOf: inputURL, encoding: .utf8)
let input = inputString.split(separator: "\n").sorted()


extension StringProtocol {
    
    var allIntegers: [Int] {
        let scanner = Scanner(string: String(self))
        var integers = [Int]()
        scanner.charactersToBeSkipped = CharacterSet.decimalDigits.inverted
        while scanner.isAtEnd == false {
            var integer = 0
            let succeeded = scanner.scanInt(&integer)
            if succeeded {
                integers.append(integer)
            }
        }
        return integers
    }
}


struct Guard: Hashable {
    var id: Int
    
    init<S>(_ string: S) where S: StringProtocol {
        self.id = string.allIntegers.last!
    }
}

struct Minute: Hashable {
    var value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    init<S>(_ string: S) where S: StringProtocol {
       self.value = string.allIntegers.last!
    }
}


enum Action {
    case startShift(Guard)
    case fallAsleep(Minute)
    case wakeUp(Minute)
    
    init<S>(_ string: S) where S: StringProtocol {
        if string.hasSuffix("shift") {
            self = .startShift(Guard(string))
        } else if string.hasSuffix("asleep") {
            self = .fallAsleep(Minute(string))
        } else if string.hasSuffix("up") {
            self = .wakeUp(Minute(string))
        } else {
            fatalError("Could not parse \(string)")
        }
    }
}

var sleepRecordsByGuard = [Guard: [Minute: Int]]()

var currentGuard = nil as Guard?
var fellAsleep = nil as Minute?

for action in input.map(Action.init) {
    switch action {
    case .startShift(let newGuard):
        currentGuard = newGuard
    case .fallAsleep(let minute):
        fellAsleep = minute
    case .wakeUp(let wokeUp):
        if let currentGuard = currentGuard, let fellAsleep = fellAsleep {
            for minute in fellAsleep.value ..< wokeUp.value {
                var sleepRecord = sleepRecordsByGuard[currentGuard, default: [Minute: Int]()]
                sleepRecord[Minute(minute), default: 0] += 1
                sleepRecordsByGuard[currentGuard] = sleepRecord
            }
        }
    }
}

let (bestGuard1, sleepRecord1) = sleepRecordsByGuard.max {
    $0.value.values.reduce(0, +) < $1.value.values.reduce(0, +)
}!

let (bestMinute1, _) = sleepRecord1.max {
    $0.value < $1.value
}!

print("Part 1:", bestGuard1.id * bestMinute1.value)


let (bestGuard2, sleepRecord2) = sleepRecordsByGuard.max {
    $0.value.values.max()! < $1.value.values.max()!
}!

let (bestMinute2, _) = sleepRecord2.max {
    $0.value < $1.value
}!

print("Part 2:", bestGuard2.id * bestMinute2.value)
