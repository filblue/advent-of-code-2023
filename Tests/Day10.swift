import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day10Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day10(
        data: """
          ...#......
          .......#..
          #.........
          ..........
          ......#...
          .#........
          .........#
          ..........
          .......#..
          #...#.....
          """
      ).part1() as! Int,
      374
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day10(
        data: """
          ...#...
          ....#..
          """
      ).part1() as! Int,
      2
    )
  }

  func testPart1WithExampleData3() throws {
    XCTAssertEqual(
      try Day10(
        data: """
          ...#....
          .....#..
          """
      ).part1() as! Int,
      4
    )
  }
  func testPart1() throws {
    XCTAssertEqual(
      try Day10().part1() as! Int,
      9545480
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day10().part2() as! Int,
      406725732046
    )
  }
}
