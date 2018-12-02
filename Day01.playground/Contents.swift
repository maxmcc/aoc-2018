import Foundation

struct RepeatSequence<Base: Collection>: Sequence, IteratorProtocol {
    var base: Base
    var iterator: Base.Iterator
    
    init(base: Base) {
        self.base = base
        self.iterator = base.makeIterator()
    }
    
    mutating func next() -> Base.Element? {
        if let element = self.iterator.next() {
            return element
        } else {
            self.iterator = self.base.makeIterator()
            return self.iterator.next()
        }
    }
}

extension Collection {
    
    func repeating() -> RepeatSequence<Self> {
        return RepeatSequence(base: self)
    }
}


func main() {
    let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
    let inputString = try! String(contentsOf: inputURL, encoding: .utf8)
    let input = inputString.split(separator: "\n").compactMap { Int($0) }

    
    print("Part 1:", input.reduce(0, +))


    var currentSum = 0
    var previouslySeenSums = Set<Int>()
    
    for value in input.repeating() {
        currentSum += value
        if previouslySeenSums.contains(currentSum) {
            print("Part 2:", currentSum)
            return
        } else {
            previouslySeenSums.insert(currentSum)
        }
    }
}

main()
