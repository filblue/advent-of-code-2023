import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day15Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day15(
        data: #"""
          .|...\....
          |.-.\.....
          .....|-...
          ........|.
          ..........
          .........\
          ..../.\\..
          .-.-/..|..
          .|....-|.\
          ..//.|....
          """#
      ).part1() as! Int,
      46
    )
  }
}
