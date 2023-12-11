import Algorithms
import CustomDump
import Foundation
import Parsing

struct Day10: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.grid = try! gridParser.parse(&input)
  }

  private let grid: [[Tile]]

  func part1() throws -> Any {
    pathsSum(expandMultiple: 2)
  }

  func part2() throws -> Any {
    pathsSum(expandMultiple: 1000000)
  }

  private func pathsSum(expandMultiple: Int) -> Int {
    let (galaxies, emptyRows, emptyColumns) = grid.findGalaxies()

    var pathsSum = 0
    for i in (0 ..< galaxies.count) {
      for j in (i+1 ..< galaxies.count) {
        let distance1 = distance(
          in: grid,
          from: galaxies[i],
          to: galaxies[j],
          emptyRows: emptyRows,
          emptyColumns: emptyColumns,
          expandMultiple: expandMultiple
        )
        pathsSum += distance1
      }
    }

    return pathsSum
  }
}

private func distance(
  in grid: [[Tile]],
  from start: (Int, Int),
  to finish: (Int, Int),
  emptyRows: Set<Int>,
  emptyColumns: Set<Int>,
  expandMultiple: Int
) -> Int {
  let startX = min(finish.0, start.0)
  let finishX = max(finish.0, start.0)
  let startY = min(finish.1, start.1)
  let finishY = max(finish.1, start.1)

  let distX = ((startX ..< finishX).map { emptyRows.contains($0) ? expandMultiple : 1 }).reduce(0, +)
  let distY = ((startY ..< finishY).map { emptyColumns.contains($0) ? expandMultiple : 1 }).reduce(0, +)

  return distX + distY
}

private extension Collection where Element == [Tile] {
  func findGalaxies() -> ([(Int, Int)], emptyRows: Set<Int>, emptyColumns: Set<Int>) {
    var galaxyPositions: [(Int, Int)] = []
    var emptyRows: Set<Int> = .init(0 ... self.count - 1)
    var emptyColumns: Set<Int> = .init(0 ... self.first!.count - 1)
    for row in self.enumerated() {
      for cell in row.element.enumerated() {
        if cell.element == .galaxy {
          galaxyPositions.append((row.offset, cell.offset))
          emptyRows.remove(row.offset)
          emptyColumns.remove(cell.offset)
        }
      }
    }
    return (galaxyPositions, emptyRows, emptyColumns)
  }
}

private let gridParser: some Parser<Substring, [[Tile]]> = Many {
  Many { Tile.parser }
} separator: {
  Whitespace(1, .vertical)
}

private enum Tile: CustomDebugStringConvertible {
  case space, galaxy

  static let parser: some Parser<Substring, Tile> = OneOf {
    ".".map { .space }
    "#".map { .galaxy }
  }

  var debugDescription: String {
    switch self {
    case .space: "."
    case .galaxy: "#"
    }
  }
}
