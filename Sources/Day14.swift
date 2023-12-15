import Algorithms
import Collections
import CustomDump
import Foundation
import Parsing
import RegexBuilder

struct Day14: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...].utf8
    self.steps = try! parser.parse(&input)
    self.steps2 = self.steps.map(step2)
  }

  private let steps: [Substring.UTF8View]
  private let steps2: [(String, Int?)]

  func part1() throws -> Any {
    steps.map(hash).reduce(0, +)
  }

  func part2() throws -> Any {
    typealias Box = OrderedDictionary<String, Int>
    var boxes: [Box] = Array(repeating: [:], count: 256)

    for step in steps2 {
      let h = hash(step.0[...].utf8)
      var box = boxes[h]
      box[step.0] = step.1
      boxes[h] = box
    }

    return boxes.enumerated()
      .map { box in
        box.element.enumerated()
          .map { (box.offset, $0.offset, $0.element.value) }
          .map(fPower)
          .reduce(0, +)
      }
      .reduce(0, +)
  }
}

private func fPower(_ boxIndex: Int, _ slotIndex: Int, _ focalLength: Int) -> Int {
  (boxIndex + 1) * (slotIndex + 1) * focalLength
}

private func step2(_ step: Substring.UTF8View) -> (String, Int?) {
  let cs = step.split(separator: "=".utf8)
  if cs.count == 1 {
    return (String(cs[0].dropLast())!, nil)
  } else {
    return (String(cs[0])!, Int(String(cs[1])!))
  }
}

private func hash(_ str: Substring.UTF8View) -> Int {
  str.map(Int.init).reduce(into: 0) { h, c in h += c; h *= 17; h = h % 256 }
}

private let parser: some Parser<Substring.UTF8View, [Substring.UTF8View]> = Many {
  OneOf {
    PrefixUpTo(",".utf8)
    Rest()
  }
} separator: {
  ",".utf8
}
