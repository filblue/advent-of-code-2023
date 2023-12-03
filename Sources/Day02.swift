import Foundation
import Parsing

struct Day02: AdventDay {
  var data: String

  var map: [[MapCell]] {
    get throws {
      var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
      var _map = try mapParser.parse(&input)
      findPertinentDigits(&_map)
      return _map
    }
  }

  func part1() throws -> Any {
    sumOfPartNumbers(in: try self.map)
  }

  func part2() throws -> Any {
    sumOfGearRatios(in: try self.map)
  }
}

func sumOfGearRatios(in map: [[MapCell]]) -> Int {
  map
    .joined()
    .compactMap { (cell: MapCell) -> [Int]? in
      switch cell {
      case let .gear(adjacentPartIds): return adjacentPartIds
      default: return nil
      }
    }
    .map { (parts: [Int]) -> Int in
      parts
        .map { (part: Int) -> Int in
          map
            .joined()
            .compactMap {
              switch $0 {
              case let .pertinentDigit(n, partId: _partId) where _partId == part:
                return n
              default:
                return nil
              }
            }
            .reduce(0, { $0 * 10 + $1 })
        }
        .reduce(1, *)
    }
    .reduce(0, +)
}

func sumOfPartNumbers(in map: [[MapCell]]) -> Int {
  var result = 0
  for i in (0...map.count-1) {
    var n = 0
    for j in (0...map[i].count-1) {
      switch map[i][j] {
      case let .pertinentDigit(x, _):
        n = (n * 10) + x
      case .space, .symbol, .digit, .gear:
        result += n
        n = 0
      }
    }
    result += n
  }
  return result
}

func findPertinentDigits(_ map: inout [[MapCell]]) {
  for row in map.enumerated() {
    for cell in row.element.enumerated() {
      if case let .symbol(c) = cell.element {
        var adjacentPartIds: [Int] = []
        for _rowOffset in (max(row.offset - 1, 0)...min(row.offset + 1, map.count - 1)) {
          for _cellOffset in (max(cell.offset - 1, 0)...min(cell.offset + 1, row.element.count - 1)) {
            if let partId = findPertinentDigitsAdjacentToDigit(
              in: &map,
              startingAt: (_rowOffset, _cellOffset),
              partId: nil
            ) {
              adjacentPartIds.append(partId)
            }
          }
        }
        if c == "*", adjacentPartIds.count == 2 {
          map[row.offset][cell.offset] = .gear(adjacentPartIds: adjacentPartIds)
        }
      }
    }
  }
}

var globalPartIdCounter = 0

func findPertinentDigitsAdjacentToDigit(
  in map: inout [[MapCell]],
  startingAt pos: (Int, Int),
  partId: Int?
) -> Int? {
  guard case let .digit(x) = map[pos.0][pos.1] else { return nil }
  let _partId: Int
  if let partId {
    _partId = partId
  } else {
    _partId = globalPartIdCounter
    globalPartIdCounter += 1
  }
  map[pos.0][pos.1] = .pertinentDigit(x, partId: _partId)
  for _cellOffset in (max(pos.1 - 1, 0)...min(pos.1 + 1, map[0].count - 1)) {
    _ = findPertinentDigitsAdjacentToDigit(
      in: &map,
      startingAt: (pos.0, _cellOffset),
      partId: _partId
    )
  }
  return _partId
}

let mapParser: some Parser<Substring, [[MapCell]]> = Many {
  mapRowParser
} separator: {
  Whitespace(1, .vertical)
}

let mapRowParser: some Parser<Substring, [MapCell]> = Many {
  mapCellParser
}

let mapCellParser: some Parser<Substring, MapCell> = OneOf {
  Digits(1).map(MapCell.digit)
  ".".map { .space }
  First().filter { !$0.isNewline }.map { .symbol($0) }
}

enum MapCell: Equatable {
  case pertinentDigit(Int, partId: Int)
  case digit(Int)
  case symbol(Character)
  case gear(adjacentPartIds: [Int])
  case space
}
