import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day17Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day17(
        data: """
          R 6 (#70c710)
          D 5 (#0dc571)
          L 2 (#5713f0)
          D 2 (#d2c081)
          R 2 (#59c680)
          D 2 (#411b91)
          L 5 (#8ceee2)
          U 2 (#caa173)
          L 1 (#1b58a2)
          U 2 (#caa171)
          R 2 (#7807d2)
          U 3 (#a77fa3)
          L 2 (#015232)
          U 2 (#7a21e3)
          """
      ).part1() as! Int,
      62
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day17(
        data: """
          R 2 (#70c710)
          D 2 (#70c710)
          L 2 (#70c710)
          U 2 (#70c710)
          """
      ).part1() as! Int,
      9
    )
  }}
