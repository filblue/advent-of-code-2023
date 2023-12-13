import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day12Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day12(
        data: """
          #.##..##.
          ..#.##.#.
          ##......#
          ##......#
          ..#.##.#.
          ..##..##.
          #.#.##.#.

          #...##..#
          #....#..#
          ..##..###
          #####.##.
          #####.##.
          ..##..###
          #....#..#
          """
      ).part1() as! Int,
      405
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day12(
        data: """
          .#..####...
          ####.##.###
          .##.#...###
          ##......###
          #######.#..
          #######.#..
          #.......###
          .##.#...###
          ####.##.###
          .#..####...
          #...###....
          .##....#...
          ###..##.###
          .##...#..##
          ..##.###.##
          """
      ).part1() as! Int,
      10
    )
  }

  func testPart1() throws {
    XCTAssertEqual(
      try Day12().part1() as! Int,
      30487
    )
  }

  func testPart2WithExampleData1() throws {
    XCTAssertEqual(
      try Day12(
        data: """
          #.##..##.
          ..#.##.#.
          ##......#
          ##......#
          ..#.##.#.
          ..##..##.
          #.#.##.#.
          """
      ).part2() as! Int,
      300
    )
  }

  func testPart2WithExampleData2() throws {
    XCTAssertEqual(
      try Day12(
        data: """
          #...##..#
          #....#..#
          ..##..###
          #####.##.
          #####.##.
          ..##..###
          #....#..#
          """
      ).part2() as! Int,
      100
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day12().part2() as! Int,
      31954
    )
  }
}
