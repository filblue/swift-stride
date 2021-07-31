
public enum Waypoint<T: Strideable> {
    case low(T)
    case high(T)
}

public typealias Point<X: Strideable, Y: Strideable> = (x: (pos: X, dur: X.Stride), y: Y)

public func stride<X: Strideable, Y: Strideable>(
    points: [Point<X, Y>],
    duration: X.Stride,
    over waypoints: [Waypoint<Y>],
    by step: Y.Stride = 1
) -> [[Point<X, Y>]] {

    let steps = stride(points.map(\.y), over: waypoints, by: step)

    var _points: [[Point<X, Y>]] = []

    var stepOffset: X.Stride? = nil
    for step in steps {

        let fy: (Y) -> Y = { $0.advanced(by: step) }
        let fposx: (X) -> X = { pos in stepOffset.map { pos.advanced(by: $0) } ?? pos }

        _points.append(
            points.map { (
                x: (pos: fposx($0.x.pos), dur: $0.x.dur),
                y: fy($0.y)
            ) }
        )

        stepOffset = stepOffset.map { $0 + duration } ?? duration
    }

    return _points
}

public func stride<T: Strideable>(
    _ m: [T],
    over waypoints: [Waypoint<T>],
    by step: T.Stride = 1
) -> [T.Stride] {

    let mUpperBound = m.max()!
    let mLowerBound = m.min()!
    let mWidth = mLowerBound.distance(to: mUpperBound)

    return stride(
        over: waypoints.map { (w) -> Waypoint<T> in
            switch w {
            case let .high(value): return .high(value.advanced(by: -mWidth))
            case .low: return w
            }
        },
        by: step
    )
    .map(mLowerBound.distance(to:))
}

public func stride<T: Strideable>(
    over waypoints: [Waypoint<T>],
    by step: T.Stride = 1
) -> [T] {

    let pairs = Array(zip(waypoints.dropLast(), waypoints.dropFirst()))

    let strides = pairs
        .compactMap { (pair: (Waypoint, Waypoint)) -> StrideThrough<T>? in
            switch (pair.0, pair.1) {
            case (.low(let v0), .high(let v1)) where v1 >= v0,
                 (.high(let v0), .high(let v1)) where v1 >= v0:
                return stride(from: v0, through: v1, by: step)
            case (.high(let v0), .low(let v1)) where v0 >= v1,
                 (.low(let v0), .low(let v1)) where v0 >= v1:
                return stride(from: v0, through: v1, by: -step)
            default:
                return nil
            }
        }

    return strides
        .map(Array.init)
        .reduce(into: [T]()) { (acc, t) in
            if let tFirst = t.first, let accLast = acc.last, tFirst == accLast {
                acc.append(contentsOf: t.dropFirst())
            } else {
                acc.append(contentsOf: t)
            }
        }
}
