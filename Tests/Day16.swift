import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day16Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day16(
        data: """
          2413432311323
          3215453535623
          3255245654254
          3446585845452
          4546657867536
          1438598798454
          4457876987766
          3637877979653
          4654967986887
          4564679986453
          1224686865563
          2546548887735
          4322674655533
          """
      ).part1() as! Int,
      102
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day16(
        data: """
          211
          321
          325
          """
      ).part1() as! Int,
      8
    )
  }

  func testPart1WithExampleData3() throws {
    XCTAssertEqual(
      try Day16(
        data: """
          241343231
          321545353
          """
      ).part1() as! Int,
      32
    )
  }

  func testPart1WithExampleData4() throws {
    XCTAssertEqual(
      try Day16(
        data: """
          24134323
          32154535
          """
      ).part1() as! Int,
      30
    )
  }

  func testPart1WithExampleData5() throws {
    XCTAssertEqual(
      try Day16(
        data: """
          213
          """
      ).part1() as! Int,
      4
    )
  }
}
