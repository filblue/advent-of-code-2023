import Foundation
import Parsing

struct Day01: AdventDay {
  var data: String

  var games: [Game] {
    get throws {
      var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
      return try gamesParser.parse(&input)
    }
  }

  func part1() throws -> Any {
    try games.sumOfValidIDs(with: .part1)
  }

  func part2() throws -> Any {
    try games.sumOfCubePowers
  }
}

extension Collection where Element == Game {
  var sumOfCubePowers: Int {
    self.map(\.cubesPower).reduce(0, +)
  }
}

extension Game {
  var cubesPower: Int {
    CubeColor.allCases
      .map { self.sets.maxCount(of: $0) }
      .reduce(1, *)
  }
}

extension Collection where Element == [GameSetSingleCubeColor] {
  func maxCount(of color: CubeColor) -> Int {
    self.map { $0.maxCount(of: color) }.max()!
  }
}

extension Collection where Element == GameSetSingleCubeColor {
  func maxCount(of color: CubeColor) -> Int {
    self.map { $0.count(of: color) }.max()!
  }
}

extension GameSetSingleCubeColor {
  func count(of color: CubeColor) -> Int {
    guard self.cubeColor == color else { return 0 }
    return self.count
  }
}

extension Collection where Element == Game {
  func sumOfValidIDs(with limits: GameLimits) -> Int {
    self
      .filter { $0.isPossible(with: limits) }
      .map(\.index)
      .reduce(0, +)
  }
}

extension Game {
  func isPossible(with limits: GameLimits) -> Bool {
    self.sets.allSatisfy { $0.isPossible(with: limits) }
  }
}

extension Collection where Element == GameSetSingleCubeColor {
  func isPossible(with limits: GameLimits) -> Bool {
    self.allSatisfy { $0.isPossible(with: limits) }
  }
}

extension GameSetSingleCubeColor {
  func isPossible(with limits: GameLimits) -> Bool {
    self.count <= limits.maxCount(self.cubeColor)
  }
}

struct GameLimits {
  var maxCount: (CubeColor) -> Int

  static let part1 = GameLimits {
    switch $0 {
    case .red: 12
    case .green: 13
    case .blue: 14
    }
  }
}

let gamesParser: some Parser<Substring, [Game]> = Many {
  gameParser
} separator: {
  Whitespace(1, .vertical)
}

struct Game: Equatable {
  let index: Int
  let sets: [[GameSetSingleCubeColor]]
}

let gameParser: some Parser<Substring, Game> = Parse(Game.init(index:sets:)) {
  Skip { "Game " }
  Int.parser()
  ": "
  Many {
    gameSetParser
  } separator: {
    "; "
  }
}

let gameSetParser: some Parser<Substring, [GameSetSingleCubeColor]> = Many {
  gameSetSingleCubeColorParser
} separator: {
  ", "
}

let gameSetSingleCubeColorParser: some Parser<Substring, GameSetSingleCubeColor> = Parse(GameSetSingleCubeColor.init(count:cubeColor:)) {
  Int.parser()
  Skip { Whitespace() }
  cubeColorParser
}

struct GameSetSingleCubeColor: Equatable {
  let count: Int
  let cubeColor: CubeColor
}

let cubeColorParser: some Parser<Substring, CubeColor> = OneOf {
  for cubeColor in CubeColor.allCases {
    cubeColor.rawValue.map { _ in cubeColor }
  }
}

enum CubeColor: String, CaseIterable { case red, green, blue }
