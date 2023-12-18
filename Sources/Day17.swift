import Algorithms
import Collections
import CustomDump
import Foundation
import Parsing
import RegexBuilder
import BTree

struct Day17: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.plan = try! parser.parse(&input)
  }

  private let plan: [(Direction, Int, Int, Direction)]

  func part1() throws -> Any {
    area(plan.map { ($0.0, $0.1) })
  }

  func part2() throws -> Any {
    area(plan.map { ($0.3, $0.2) })
  }
}

private func area(_ moves: [(Direction, Int)]) -> Int {
  var pos = (0, 0)
  var poss = [pos]

  for move in moves {
    let _pos = (pos.0 + move.0.offset.0 * move.1, pos.1 + move.0.offset.1 * move.1)
    poss.append(_pos)
    pos = _pos
  }
  let circumference = moves.map { $0.1 }.reduce(0, +)

  let area = poss
    .adjacentPairs()
    .map { ($0.1 * $1.0) - ($0.0 * $1.1) }
    .reduce(0, +)

  return area / 2 + circumference / 2 + 1
}

private enum Direction: String, CaseIterable, Codable, Hashable {
  case north, west, south, east

  var offset: (Int, Int) {
    switch self {
    case .north: (-1, 0)
    case .west: (0, 1)
    case .south: (1, 0)
    case .east: (0, -1)
    }
  }
}

extension Direction: CustomDebugStringConvertible {
  var debugDescription: String { String(self.rawValue.prefix(1)) }
}

private let parser: some Parser<Substring, [(Direction, Int, Int, Direction)]> = Many {
  OneOf {
    "U".map { Direction.north }
    "R".map { Direction.west }
    "D".map { Direction.south }
    "L".map { Direction.east }
  }
  Whitespace(1, .horizontal)
  Int.parser()
  Skip { " (#" }
  Prefix(5).map { Int($0, radix: 16)! }
  OneOf {
    "3".map { Direction.north }
    "0".map { Direction.west }
    "1".map { Direction.south }
    "2".map { Direction.east }
  }
  Skip { ")" }
} separator: {
  Whitespace(1, .vertical)
}
