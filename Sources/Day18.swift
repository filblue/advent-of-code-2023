import Algorithms
import Collections
import CustomDump
import Foundation
import Parsing
import RegexBuilder
import BTree

struct Day18: AdventDay {
  init(data: String) {
    var input = data.trimmingCharacters(in: .whitespacesAndNewlines)[...]
    let parsed = try! parser.parse(&input)
    self.workflows = Dictionary(grouping: parsed.0, by: \.name).mapValues { $0[0] }
    self.parts = parsed.1
  }

  private let workflows: [Substring: Workflow]
  private let parts: [PartRating]

  func part1() throws -> Any {
    parts
      .filter { isAccepted($0, workflows) }
      .map { $0.x.lowerBound + $0.m.lowerBound + $0.a.lowerBound + $0.s.lowerBound }
      .reduce(0, +)
  }

  func part2() throws -> Any {
    var q: [(Substring, PartRating)] = [("in", .fullPower)]
    var result: [PartRating] = []
    while !q.isEmpty {
      let (w, p) = q.removeFirst()
      switch w {
      case "A": result.append(p)
      case "R": continue
      default: q.append(contentsOf: workflows[w]!.apply2(p))
      }
    }

    return result
      .map { [$0.x, $0.m, $0.a, $0.s].map(\.count).reduce(1, *) }
      .reduce(0, +)
  }
}

private func isAccepted(
_ part: PartRating,
_ workflows: [Substring: Workflow]
) -> Bool {
  var wKey = "in"[...]
  while !["A", "R"].contains(wKey) {
    let w = workflows[wKey]!
    wKey = w.apply(part)
  }
  return wKey == "A"
}

private struct Workflow {
  let name: Substring
  let rules: [Rule]
  let fallback: Substring

  func apply(_ part: PartRating) -> Substring {
    for r in rules {
      if let next = r.apply(part) { return next }
    }
    return fallback
  }

  func apply2(_ part: PartRating) -> [(Substring, PartRating)] {
    var result: [(Substring, PartRating)] = []
    var _part = part
    for r in rules {
      let next = r.apply2(_part)
      if !next.passing.isEmpty { result.append((r.destination, next.passing)) }
      if !next.nonPassing.isEmpty { _part = next.nonPassing }
    }
    if !_part.isEmpty {
      result.append((fallback, _part))
    }
    return result
  }

  static let parser: some Parser<Substring, Self> = Parse(Workflow.init) {
    CharacterSet.alphanumerics
    "{"
    Many {
      Rule.parser
    } separator: {
      ","
    }
    ","
    CharacterSet.alphanumerics
    "}"
  }

  struct Rule {
    let category: WritableKeyPath<PartRating, Range<Int>>
    let op: Op
    let value: Int
    let destination: Substring

    func apply(_ part: PartRating) -> Substring? {
      let r = part[keyPath: category].lowerBound
      guard op.fn(r, value) else { return nil }
      return destination
    }

    func apply2(_ part: PartRating) -> (passing: PartRating, nonPassing: PartRating) { (
      passing: {
        var _part = part
        _part[keyPath: category] = _part[keyPath: category].clamped(to: passingRange)
        return _part
      }(),
      nonPassing: {
        var _part = part
        _part[keyPath: category] = _part[keyPath: category].clamped(to: nonPassingRange)
        return _part
      }()
    ) }

    var passingRange: Range<Int> {
      switch op {
      case .lt: (1 ..< value)
      case .gt: (value+1 ..< 4001)
      }
    }

    var nonPassingRange: Range<Int> {
      switch op {
      case .lt: (value ..< 4001)
      case .gt: (1 ..< value+1)
      }
    }

    static let parser: some Parser<Substring, Self> = Parse(Rule.init) {
      OneOf {
        "x".map { \PartRating.x }
        "m".map { \PartRating.m }
        "a".map { \PartRating.a }
        "s".map { \PartRating.s }
      }
      Op.parser
      Int.parser()
      ":"
      CharacterSet.alphanumerics
    }

    enum Op {
      case lt, gt

      static let parser: some Parser<Substring, Self> = OneOf {
        "<".map { .lt }
        ">".map { .gt }
      }

      var fn: (Int, Int) -> Bool {
        switch self {
        case .lt: return { $0 < $1 }
        case .gt: return { $0 > $1 }
        }
      }
    }
  }
}

private struct PartRating {
  var x, m, a, s: Range<Int>

  static let fullPower: Self = PartRating(
    x: .init(1 ... 4000),
    m: .init(1 ... 4000),
    a: .init(1 ... 4000),
    s: .init(1 ... 4000)
  )

  var isEmpty: Bool { x.isEmpty || m.isEmpty || a.isEmpty || s.isEmpty }
}

private extension PartRating {
  init(x: Int, m: Int, a: Int, s: Int) {
    self.x = (x ..< x+1)
    self.m = (m ..< m+1)
    self.a = (a ..< a+1)
    self.s = (s ..< s+1)
  }
}

private let parser: some Parser<Substring, ([Workflow], [PartRating])> = Parse {
  Many {
    Workflow.parser
  } separator: {
    Whitespace(1, .vertical)
  }
  Skip { Whitespace(2, .vertical) }
  Many {
    Parse(PartRating.init) {
      "{x="
      Int.parser()
      ",m="
      Int.parser()
      ",a="
      Int.parser()
      ",s="
      Int.parser()
      "}"
    }
  } separator: {
    Whitespace(1, .vertical)
  }
}
