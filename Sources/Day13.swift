import Algorithms
import CustomDump
import Foundation
import Parsing
import RegexBuilder

struct Day13: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    self.platform = try! parser.parse(&input)
  }

  private let platform: [[Substring]]

  func part1() throws -> Any {
    var _platform = platform
    tilt(&_platform, .north)
    return totalLoad(_platform)
  }

  func part2() throws -> Any {
    var _platform = platform
    cycle(&_platform, count: 1000000000)
    return totalLoad(_platform)
  }
}

private func cycle(_ platform: inout [[Substring]], count: Int) {
  var i = 0
  while i < count {
    let cacheKey = CacheKey(platform)
    if let _computed = computed.firstIndex(of: cacheKey) {
      let loopSize = computed.count - _computed
      let remaining = count - 1 - i
      if remaining > loopSize {
        let loopsToSkip = remaining / loopSize
        i += (loopsToSkip * loopSize)
      }
    }
    cycle(&platform)
    computed.append(cacheKey)
    i += 1
  }
}

private struct CacheKey: Hashable {
  let platform: String
  init(_ platform: [[Substring]]) {
    self.platform = platform.map { $0.joined() }.joined()
  }
}

private var computed: [CacheKey] = []

private func cycle(_ platform: inout [[Substring]]) {
  for d in Direction.allCases {
    tilt(&platform, d)
  }
}

private func totalLoad(_ platform: [[Substring]]) -> Int {
  var totalLoad = 0
  for i in (0 ..< platform.count) {
    for j in (0 ..< platform[0].count) {
      if platform[i][j] == "O" {
        totalLoad += (platform.count - i)
      }
    }
  }
  return totalLoad
}

private func tilt(_ platform: inout [[Substring]], _ direction: Direction) {
  var `is` = Array((0 ... platform.count-1))
  if direction.shouldReverseI { `is` = `is`.reversed() }
  var js = Array((0 ... platform[0].count-1))
  if direction.shouldReverseJ { js = js.reversed() }
  for i in `is` {
    for j in js {
      var src = (i, j)
      var dst = (i + direction.offset.0, j + direction.offset.1)
      while (
        src.0 >= 0 && src.0 < platform.count &&
        dst.0 >= 0 && dst.0 < platform.count &&
        src.1 >= 0 && src.1 < platform[0].count &&
        dst.1 >= 0 && dst.1 < platform[0].count &&
        platform[src.0][src.1] == "O" &&
        platform[dst.0][dst.1] == "."
      ) {
        platform[src.0][src.1] = "."
        platform[dst.0][dst.1] = "O"
        src = dst
        dst = (dst.0 + direction.offset.0, dst.1 + direction.offset.1)
      }
    }
  }
}

private enum Direction: CaseIterable {
  case north, west, south, east

  var offset: (Int, Int) {
    switch self {
    case .north: (-1, 0)
    case .west: (0, -1)
    case .south: (1, 0)
    case .east: (0, 1)
    }
  }

  var shouldReverseI: Bool { self == .south }

  var shouldReverseJ: Bool { self == .east }
}

private let parser: some Parser<Substring, [[Substring]]> = Many {
  Many {
    Prefix(1, while: { !$0.isNewline })
  }
} separator: {
  Whitespace(1, .vertical)
}
