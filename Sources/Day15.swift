import Algorithms
import Collections
import CustomDump
import Foundation
import Parsing
import RegexBuilder

struct Day15: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.grid = try! parser.parse(&input)
  }

  private let grid: [[Substring]]

  func part1() throws -> Any {
    tilesEnergized(grid, ((0, 0), .west))
  }

  func part2() throws -> Any {
    var allStarts: [((Int, Int), Direction)] = []
    for i in (0 ... (grid.count - 1)) {
      allStarts.append(((i, 0), .west))
      allStarts.append(((i, grid[0].count - 1), .east))
    }
    for j in (0 ... (grid[0].count - 1)) {
      allStarts.append(((0, j), .south))
      allStarts.append(((grid.count - 1, j), .north))
    }
    return allStarts.map { tilesEnergized(grid, $0) }.max()!
  }
}

private func tilesEnergized(
  _ grid: [[Substring]],
  _ start: ((Int, Int), Direction)
) -> Int {
  var queue: [((Int, Int), Direction)] = [start]
  var visited: [[Set<Direction>]] = grid.map { $0.map { _ in [] } }
  while !queue.isEmpty {
    let (pos, direction) = queue.removeFirst()
    if visited[pos.0][pos.1].contains(direction) { continue }
    visited[pos.0][pos.1].insert(direction)
    for next in direction.combine(with: grid[pos.0][pos.1]) {
      let _pos = (pos.0 + next.offset.0, pos.1 + next.offset.1)
      guard (0 ..< grid.count).contains(_pos.0), (0 ..< grid[0].count).contains(_pos.1)
      else { continue }
      queue.append((_pos, next))
    }
  }
  return visited.map { $0.filter { !$0.isEmpty }.count }.reduce(0, +)
}

private enum Direction: CaseIterable {
  case north, west, south, east

  var offset: (Int, Int) {
    switch self {
    case .north: (-1, 0)
    case .west: (0, 1)
    case .south: (1, 0)
    case .east: (0, -1)
    }
  }

  func combine(with tile: Substring) -> [Direction] {
    switch (tile, self) {
    case (".", _): return [self]

    case ("/", .north): return [.west]
    case ("/", .west): return [.north]
    case ("/", .south): return [.east]
    case ("/", .east): return [.south]

    case (#"\"#, .north): return [.east]
    case (#"\"#, .west): return [.south]
    case (#"\"#, .south): return [.west]
    case (#"\"#, .east): return [.north]

    case ("|", .north): return [.north]
    case ("|", .west): return [.north, .south]
    case ("|", .south): return [.south]
    case ("|", .east): return [.north, .south]

    case ("-", .north): return [.east, .west]
    case ("-", .west): return [.west]
    case ("-", .south): return [.east, .west]
    case ("-", .east): return [.east]

    default: fatalError("\(tile), \(self)")
    }
  }
}

private let parser: some Parser<Substring, [[Substring]]> = Many {
  Many {
    Prefix(1) { !$0.isWhitespace }
  }
} separator: {
  Whitespace(1, .vertical)
}
