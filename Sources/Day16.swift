import Algorithms
import Collections
import CustomDump
import Foundation
import Parsing
import RegexBuilder
import BTree

struct Day16: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.grid = try! parser.parse(&input)
  }

  private let grid: [[Int]]

  func part1() throws -> Any {
    minLoss(grid, (1 ... 3))
  }

  func part2() throws -> Any {
    minLoss(grid, (4 ... 10))
  }
}

private struct CountedDirection: Hashable {
  let dir: Direction
  let count: Int
}

extension CountedDirection: CustomDebugStringConvertible {
  var debugDescription: String { "\(dir)\(count)" }
}

private typealias Loss = OrderedDictionary<CountedDirection, Int>

private struct QueueItem {
  let x: Int
  let y: Int
  let cost: Int
  let cDir: CountedDirection?

  var key: Key { Key(x: x, y: y, cDir: cDir) }

  func go(_ newDirection: CountedDirection) -> CountedDirection? {
    guard let cDir else { return newDirection }
    guard !newDirection.dir.isReverse(of: cDir.dir) else { return nil }
    guard newDirection.dir != cDir.dir else { return nil }
    return newDirection
  }

  struct Key: Hashable {
    let x: Int
    let y: Int
    let cDir: CountedDirection?
  }
}

extension QueueItem: Comparable {
  static func < (lhs: QueueItem, rhs: QueueItem) -> Bool {
    (lhs.cost, lhs.cDir?.count ?? 0) < (rhs.cost, rhs.cDir?.count ?? 0)
  }
}

private func minLoss(_ grid: [[Int]], _ lineRange: ClosedRange<Int>) -> Int {
  var _minLoss: [[Loss]] = grid.map { $0.map { _ in [:] } }
  var queue: SortedSet<QueueItem> = .init([QueueItem(x: 0, y: 0, cost: 0, cDir: nil)])
  var visited: Set<QueueItem.Key> = []
  while !queue.isEmpty {
    let step = queue.removeFirst()
    if visited.contains(step.key) { continue }
    visited.insert(step.key)
    if step.x == grid.count - 1, step.y == grid[0].count - 1 { return step.cost }
    for d in Direction.allCases {
      for l in lineRange {
        guard let newDir = step.go(.init(dir: d, count: l)) else { continue }
        let _pos = (step.x + d.offset.0 * l, step.y + d.offset.1 * l)
        guard (0 ..< grid.count).contains(_pos.0), (0 ..< grid[0].count).contains(_pos.1)
        else { continue }
        let cost = step.cost + (1 ... l).map { grid[step.x + d.offset.0 * $0][step.y + d.offset.1 * $0] }.reduce(0, +)
        var orIs = false
        for c in (1 ... newDir.count) {
          if let loss = _minLoss[_pos.0][_pos.1][CountedDirection(dir: newDir.dir, count: c)], loss <= cost {
            orIs = true
          }
        }
        if !orIs {
          _minLoss[_pos.0][_pos.1][newDir] = cost
          queue.insert(QueueItem(x: _pos.0, y: _pos.1, cost: cost, cDir: newDir))
        }
      }
    }
  }
  fatalError()
}

private enum Direction: String, CaseIterable, Codable {
  case north, west, south, east

  var offset: (Int, Int) {
    switch self {
    case .north: (-1, 0)
    case .west: (0, 1)
    case .south: (1, 0)
    case .east: (0, -1)
    }
  }

  func isReverse(of direction: Direction) -> Bool {
    (self.offset.0 == -direction.offset.0) && (self.offset.1 == -direction.offset.1)
  }
}

extension Direction: CustomDebugStringConvertible {
  var debugDescription: String { String(self.rawValue.prefix(1)) }
}

private let parser: some Parser<Substring, [[Int]]> = Many {
  Many {
    Prefix(1, while: { !$0.isWhitespace }).map { Int($0)! }
  }
} separator: {
  Whitespace(1, .vertical)
}
