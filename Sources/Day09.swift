import Algorithms
import CustomDump
import Foundation
import Parsing

struct Day09: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.grid = try! gridParser.parse(&input)
  }

  private let grid: [[Tile]]

  func part1() throws -> Any {
    farthest(in: grid)
  }

  func part2() throws -> Any {
    innerCount(grid: grid)
  }
}

private func innerCount(grid: [[Tile]]) -> Int {
  let expanded = grid.expanded
  let start = expanded.start
  var stepsExpanded = steps(expanded)

  var stack: [[Int]] = [[0, 0]]
  stepsExpanded[0][0] = -1
  while !stack.isEmpty {
    let pos = stack.removeFirst()
    let (x, y) = (pos[0], pos[1])

    for offset in [[-1, 0], [1, 0], [0, -1], [0, 1]] {
      let _x = x + offset[0]
      guard (0 ..< expanded.count).contains(_x) else { continue }
      let _y = y + offset[1]
      guard (0 ..< expanded[_x].count).contains(_y) else { continue }
      guard stepsExpanded[_x][_y] == 0, start != (_x, _y) else { continue }
      stepsExpanded[_x][_y] = -1
      stack.append([_x, _y])
    }
  }

  let stepsOriginal = steps(grid)
  var innerCount = 0
  for row in stepsOriginal.enumerated() {
    for step in row.element.enumerated() {
      if step.element == 0,
         grid[row.offset][step.offset] != .st,
         stepsExpanded[row.offset * 3 + 1][step.offset * 3 + 1] == 0 {        
        innerCount += 1
      }
    }
  }

  return innerCount
}

private extension Collection where Element == [Tile] {
  var expanded: [[Tile]] {
    func expand(_ tile: Tile) -> [[Tile]] {
      var result: [[Tile]] = Array(repeating: Array(repeating: .gr, count: 3), count: 3)
      result[1][1] = tile
      for offset in tile.connections where offset[0] != 0 {
        result[1 + offset[0]][1] = .ns
      }
      for offset in tile.connections where offset[1] != 0 {
        result[1][1 + offset[1]] = .ew
      }
      return result
    }
    var expanded: [[Tile]] = []
    for row in self {
      let expandedRow = row.map(expand)
      var rows: [[Tile]] = []
      for i in (0 ..< 3) {
        rows.append([])
        for j in (0 ..< expandedRow.count) {
          rows[i].append(contentsOf: expandedRow[j][i])
        }
      }
      expanded.append(contentsOf: rows)
    }
    return expanded
  }
}

private func farthest(in grid: [[Tile]]) -> Int {
  steps(grid).map { $0.max()! }.max()!
}

private extension Collection where Element == [Tile] {
  var start: (Int, Int) {
    self.enumerated()
      .firstNonNil { row in row.element.enumerated().firstNonNil { tile in
        tile.element == .st ? (row.offset, tile.offset) : nil
      } }!
  }
}

private func steps(_ grid: [[Tile]]) -> [[Int]] {
  let start = grid.start

  var steps = grid.map { $0.map { _ in 0 } }
  var stack: [(Int, Int)] = [start]

  while !stack.isEmpty {
    let (x, y) = stack.removeFirst()

    var didFindConnection = false
    for offset in grid[x][y].connections {
      let _x = x + offset[0]
      guard (0 ..< grid.count).contains(_x) else { continue }
      let _y = y + offset[1]
      guard (0 ..< grid[_x].count).contains(_y) else { continue }
      guard grid[_x][_y].connections.contains(offset.map { -1 * $0 }) else { continue }
      guard steps[_x][_y] == 0, start != (_x, _y) else { continue }
      didFindConnection = true
      steps[_x][_y] = steps[x][y] + 1
      stack.append((_x, _y))
    }
    if steps[x][y] == 1, !didFindConnection {
      steps[x][y] = 0
    }
  }

  return steps
}

private let gridParser: some Parser<Substring, [[Tile]]> = Many {
  Many { Tile.parser }
} separator: {
  Whitespace(1, .vertical)
}

private enum Tile {
  case ns, ew, ne, nw, sw, se, gr, st

  var connections: [[Int]] {
    switch self {
    case .ns: [[-1, 0], [1, 0]]
    case .ew: [[0, -1], [0, 1]]
    case .ne: [[-1, 0], [0, 1]]
    case .nw: [[-1, 0], [0, -1]]
    case .sw: [[1, 0], [0, -1]]
    case .se: [[1, 0], [0, 1]]
    case .gr: []
    case .st: [[-1, 0], [1, 0], [0, -1], [0, 1]]
    }
  }

  static let parser: some Parser<Substring, Tile> = OneOf {
    "|".map { .ns }
    "-".map { .ew }
    "L".map { .ne }
    "J".map { .nw }
    "7".map { .sw }
    "F".map { .se }
    ".".map { .gr }
    "S".map { .st }
  }
}
