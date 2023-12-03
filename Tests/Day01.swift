import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

private let exampleData = """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """

final class Day01Tests: XCTestCase {
  func testPart2WithExampleData() throws {
    XCTAssertEqual(
      try Day01(data: exampleData).part2() as! Int,
      2286
    )
  }

  func testGameSetsMaxCubeColorCount() {
    XCTAssertEqual(
      [
        [
        GameSetSingleCubeColor(count: 3, cubeColor: .blue),
        GameSetSingleCubeColor(count: 4, cubeColor: .red),
      ],
        [
          GameSetSingleCubeColor(count: 5, cubeColor: .blue),
          GameSetSingleCubeColor(count: 4, cubeColor: .green),
        ],
      ].maxCount(of: .blue),
      5
    )
  }

  func testGameSetMaxCubeColorCount() {
    XCTAssertEqual(
      [
        GameSetSingleCubeColor(count: 3, cubeColor: .blue),
        GameSetSingleCubeColor(count: 4, cubeColor: .red),
      ].maxCount(of: .blue),
      3
    )
    XCTAssertEqual(
      [
        GameSetSingleCubeColor(count: 3, cubeColor: .blue),
        GameSetSingleCubeColor(count: 4, cubeColor: .red),
      ].maxCount(of: .red),
      4
    )
    XCTAssertEqual(
      [
        GameSetSingleCubeColor(count: 3, cubeColor: .blue),
        GameSetSingleCubeColor(count: 4, cubeColor: .red),
      ].maxCount(of: .green),
      0
    )
  }

  func testGameSetSingleCubeColorCount() {
    XCTAssertEqual(GameSetSingleCubeColor(count: 2, cubeColor: .blue).count(of: .blue), 2)
    XCTAssertEqual(GameSetSingleCubeColor(count: 2, cubeColor: .blue).count(of: .red), 0)
  }

  func testExampleDataResult() throws {
    XCTAssertEqual(
      try Day01(data: exampleData).part1() as! Int,
      8
    )
  }

  func testGamesParser() throws {
    var input = exampleData[...]
    XCTAssertNoDifference(
      try gamesParser.parse(&input),
      [
        Game(
          index: 1,
          sets: [
            [
              .init(count: 3, cubeColor: .blue),
              .init(count: 4, cubeColor: .red),
            ],
            [
              .init(count: 1, cubeColor: .red),
              .init(count: 2, cubeColor: .green),
              .init(count: 6, cubeColor: .blue),
            ],
            [
              .init(count: 2, cubeColor: .green),
            ],
          ]
        ),
        Game(
          index: 2,
          sets: [
            [
              .init(count: 1, cubeColor: .blue),
              .init(count: 2, cubeColor: .green),
            ],
            [
              .init(count: 3, cubeColor: .green),
              .init(count: 4, cubeColor: .blue),
              .init(count: 1, cubeColor: .red),
            ],
            [
              .init(count: 1, cubeColor: .green),
              .init(count: 1, cubeColor: .blue),
            ],
          ]
        ),
        Game(
          index: 3,
          sets: [
            [
              .init(count: 8, cubeColor: .green),
              .init(count: 6, cubeColor: .blue),
              .init(count: 20, cubeColor: .red),
            ],
            [
              .init(count: 5, cubeColor: .blue),
              .init(count: 4, cubeColor: .red),
              .init(count: 13, cubeColor: .green),
            ],
            [
              .init(count: 5, cubeColor: .green),
              .init(count: 1, cubeColor: .red),
            ],
          ]
        ),
        Game(
          index: 4,
          sets: [
            [
              .init(count: 1, cubeColor: .green),
              .init(count: 3, cubeColor: .red),
              .init(count: 6, cubeColor: .blue),
            ],
            [
              .init(count: 3, cubeColor: .green),
              .init(count: 6, cubeColor: .red),
            ],
            [
              .init(count: 3, cubeColor: .green),
              .init(count: 15, cubeColor: .blue),
              .init(count: 14, cubeColor: .red),
            ],
          ]
        ),
        Game(
          index: 5,
          sets: [
            [
              .init(count: 6, cubeColor: .red),
              .init(count: 1, cubeColor: .blue),
              .init(count: 3, cubeColor: .green),
            ],
            [
              .init(count: 2, cubeColor: .blue),
              .init(count: 1, cubeColor: .red),
              .init(count: 2, cubeColor: .green),
            ],
          ]
        ),
      ]
    )
  }

  func testGameParser() throws {
    var input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"[...]
    XCTAssertEqual(
      try gameParser.parse(&input),
      Game(
        index: 1,
        sets: [
          [
            .init(count: 3, cubeColor: .blue),
            .init(count: 4, cubeColor: .red),
          ],
          [
            .init(count: 1, cubeColor: .red),
            .init(count: 2, cubeColor: .green),
            .init(count: 6, cubeColor: .blue),
          ],
          [
            .init(count: 2, cubeColor: .green),
          ],
        ]
      )
    )
  }

  func testGameSetParser() throws {
    var input = "3 blue, 4 red"[...]
    XCTAssertEqual(
      try gameSetParser.parse(&input),
      [
        .init(count: 3, cubeColor: .blue),
        .init(count: 4, cubeColor: .red),
      ]
    )
    input = "4 green"[...]
    XCTAssertEqual(
      try gameSetParser.parse(&input),
      [
        .init(count: 4, cubeColor: .green),
      ]
    )
  }

  func testGameSetSingleCubeColorParser() throws {
    var input = "3 blue"[...]
    XCTAssertEqual(try gameSetSingleCubeColorParser.parse(&input), .init(count: 3, cubeColor: .blue))
    input = "4 red"[...]
    XCTAssertEqual(try gameSetSingleCubeColorParser.parse(&input), .init(count: 4, cubeColor: .red))
  }

  func testCubeColorParser() throws {
    var input = "red"[...]
    XCTAssertEqual(try cubeColorParser.parse(&input), .red)
    input = "green"[...]
    XCTAssertEqual(try cubeColorParser.parse(&input), .green)
    input = "blue"[...]
    XCTAssertEqual(try cubeColorParser.parse(&input), .blue)
  }
}
