import CustomDump
import Foundation
import Parsing
import XCTest

@testable import AdventOfCode

final class Day09Tests: XCTestCase {
  func testPart1WithExampleData1() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          .....
          .S-7.
          .|.|.
          .L-J.
          .....
          """
      ).part1() as! Int,
      4
    )
  }

  func testPart1WithExampleData2() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          -L|F7
          7S-7|
          L|7||
          -L-J|
          L|-JF
          """
      ).part1() as! Int,
      4
    )
  }

  func testPart1WithExampleData3() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          ..F7.
          .FJ|.
          SJ.L7
          |F--J
          LJ...
          """
      ).part1() as! Int,
      8
    )
  }

  func testPart1WithExampleData4() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          7-F7-
          .FJ|7
          SJLL7
          |F--J
          LJ.LJ
          """
      ).part1() as! Int,
      8
    )
  }

  func testPart1() throws {
    XCTAssertEqual(
      try Day09().part1() as! Int,
      7102
    )
  }

  func testPart2WithExampleData1() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          .....
          .S-7.
          .|.|.
          .L-J.
          .....
          """
      ).part2() as! Int,
      1
    )
  }


  func testPart2WithExampleData2() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          ...........
          .S-------7.
          .|F-----7|.
          .||.....||.
          .||.....||.
          .|L-7.F-J|.
          .|..|.|..|.
          .L--J.L--J.
          ...........
          """
      ).part2() as! Int,
      4
    )
  }

  func testPart2WithExampleData3() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          ..........
          .S------7.
          .|F----7|.
          .||....||.
          .||....||.
          .|L-7F-J|.
          .|..||..|.
          .L--JL--J.
          ..........
          """
      ).part2() as! Int,
      4
    )
  }

  func testPart2WithExampleData4() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          .F----7F7F7F7F-7....
          .|F--7||||||||FJ....
          .||.FJ||||||||L7....
          FJL7L7LJLJ||LJ.L-7..
          L--J.L7...LJS7F-7L7.
          ....F-J..F7FJ|L7L7L7
          ....L7.F7||L7|.L7L7|
          .....|FJLJ|FJ|F7|.LJ
          ....FJL-7.||.||||...
          ....L---J.LJ.LJLJ...
          """
      ).part2() as! Int,
      8
    )
  }

  func testPart2WithExampleData5() throws {
    XCTAssertEqual(
      try Day09(
        data: """
          FF7FSF7F7F7F7F7F---7
          L|LJ||||||||||||F--J
          FL-7LJLJ||||||LJL-77
          F--JF--7||LJLJ7F7FJ-
          L---JF-JLJ.||-FJLJJ7
          |F|F-JF---7F7-L7L|7|
          |FFJF7L7F-JF7|JL---7
          7-L-JL7||F7|L7F-7F7|
          L.L7LFJ|||||FJL7||LJ
          L7JLJL-JLJLJL--JLJ.L
          """
      ).part2() as! Int,
      10
    )
  }

  func testPart2() throws {
    XCTAssertEqual(
      try Day09().part2() as! Int,
      363
    )
  }
}
