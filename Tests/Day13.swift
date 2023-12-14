import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day13Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day13(
        data: """
          O....#....
          O.OO#....#
          .....##...
          OO.#O....O
          .O.....O#.
          O.#..O.#.#
          ..O..#O..O
          .......O..
          #....###..
          #OO..#....
          """
      ).part1() as! Int,
      136
    )
  }

  func testPart1() throws {
    XCTAssertEqual(
      try Day13().part1() as! Int,
      106378
    )
  }

  func testPart2WithExampleData1() throws {
    XCTAssertEqual(
      try Day13(
        data: """
          O....#....
          O.OO#....#
          .....##...
          OO.#O....O
          .O.....O#.
          O.#..O.#.#
          ..O..#O..O
          .......O..
          #....###..
          #OO..#....
          """
      ).part2() as! Int,
      64
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day13().part2() as! Int,
      90795
    )
  }
}
