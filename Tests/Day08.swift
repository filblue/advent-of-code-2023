import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day08Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day08(
        data: """
          0 3 6 9 12 15
          1 3 6 10 15 21
          10 13 16 21 30 45
          """
      ).part1() as! Int,
      114
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day08(
        data: """
          -3 0 3 6 9 12 15
          """
      ).part1() as! Int,
      18
    )
  }

  func testPart2WithExampleData1() throws {
    XCTAssertEqual(
      try Day08(
        data: """
          10 13 16 21 30 45
          """
      ).part2() as! Int,
      5
    )
  }

  func testPart2WithExampleData2() throws {
    XCTAssertEqual(
      try Day08(
        data: """
          0 3 6 9 12 15
          1 3 6 10 15 21
          10 13 16 21 30 45
          """
      ).part2() as! Int,
      2
    )
  }

  func testPart2WithExampleData3() throws {
    XCTAssertEqual(
      try Day08(
        data: """
          0 -3 -6 -7 1 43 201 703 2093 5515 13138 28727 58310 110773 197987 333665 529470 785825 1073258 1297757 1240279
          """
      ).part2() as! Int,
      5
    )
  }

  func testPart1() throws {
    XCTAssertEqual(
      try Day08().part1() as! Int,
      2105961943
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day08().part2() as! Int,
      1019
    )
  }
}
