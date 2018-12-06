import Foundation

let inputURL = Bundle.main.url(forResource: "Input", withExtension: "txt")!
let inputString = try! String(contentsOf: inputURL, encoding: .utf8)
let inputLines = inputString.split(separator: "\n")

struct Coordinate: Hashable {
    var x: Int
    var y: Int

    init<S>(_ string: S) where S: StringProtocol {
        let components = string.split { $0 == " " || $0 == "," }
        self.x = Int(components.first!)!
        self.y = Int(components.last!)!
    }

    func distanceTo(x: Int, y: Int) -> Int {
        return abs(x - self.x) + abs(y - self.y)
    }
}

let coordinates = inputLines.map(Coordinate.init)

let minX = coordinates.min { $0.x < $1.x }!.x
let maxX = coordinates.max { $0.x < $1.x }!.x
let minY = coordinates.min { $0.y < $1.y }!.y
let maxY = coordinates.max { $0.y < $1.y }!.y

var capturedCells = [Coordinate: Int]()
var infiniteArea = Set<Coordinate>()

for x in minX...maxX {
    for y in minY...maxY {
        var closest = nil as Coordinate?
        var minimumDistance = Int.max

        for coordinate in coordinates {
            let distance = coordinate.distanceTo(x: x, y: y)
            if distance == minimumDistance {
                closest = nil
            } else if distance < minimumDistance {
                minimumDistance = distance
                closest = coordinate
            }
        }

        if let closest = closest {
            capturedCells[closest, default: 0] += 1
            if x == minX || x == maxX || y == minY || y == maxY {
                infiniteArea.insert(closest)
            }
        }
    }
}

let maximumArea = capturedCells.compactMap {
    infiniteArea.contains($0.key) ? nil : $0.value
}.max()!
print("Part 1:", maximumArea)


var safeCellCount = 0

for x in minX...maxX {
    for y in minY...maxY {
        let totalDistance = coordinates.reduce(into: 0) { total, coordinate in
            total += coordinate.distanceTo(x: x, y: y)
        }
        if totalDistance < 10_000 {
            safeCellCount += 1
        }
    }
}

print("Part 2:", safeCellCount)
