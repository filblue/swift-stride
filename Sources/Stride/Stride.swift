
public enum Waypoint<T: Strideable> {
    case low(T)
    case high(T)
}

public typealias PointX<X: Strideable> = (pos: X, dur: X.Stride)
public typealias Point<X: Strideable, Y: Strideable> = (x: PointX<X>, y: Y?)

public func stride<X: Strideable, Y: Strideable>(
    points: [Point<X, Y>],
    duration: X.Stride,
    over waypoints: [Waypoint<Y>],
    by step: Y.Stride = 1
)
-> [[Point<X, Y>]]
{
    let ys = stride(ys: points.compactMap(\.y), over: waypoints, by: step)
    let xs = stride(xs: points.map(\.x), duration: duration, count: ys.count)
    return zip(xs, ys).map { Array(zip($0, $1)) }
}

public func stride<X: Strideable>(
    xs: [PointX<X>],
    duration: X.Stride,
    count: Int
)
-> [[PointX<X>]]
{
    var _points: [[PointX<X>]] = []
    var stepOffset: X.Stride? = nil
    for _ in 0...count {
        _points.append(
            xs.map { x in (
                pos: stepOffset.map { x.pos.advanced(by: $0) } ?? x.pos,
                dur: x.dur
            ) }
        )
        stepOffset = stepOffset.map { $0 + duration } ?? duration
    }
    return _points
}

public func stride<Y: Strideable>(
    ys: [Y?],
    over waypoints: [Waypoint<Y>],
    by step: Y.Stride = 1
)
-> [[Y?]]
{
    let _ys = ys.compactMap { $0 }
    return stride(range: _ys.min()!..._ys.max()!, over: waypoints, by: step)
        .map { step in
            ys.map { $0.map { $0.advanced(by: step) } }
        }
}

public func stride<T: Strideable>(
    range: ClosedRange<T>,
    over waypoints: [Waypoint<T>],
    by step: T.Stride = 1
)
-> [T.Stride]
{
    let width = range.lowerBound.distance(to: range.upperBound)
    return stride(
        over: waypoints.map { (w) -> Waypoint<T> in
            switch w {
            case let .high(value): return .high(value.advanced(by: -width))
            case .low: return w
            }
        },
        by: step
    )
    .map(range.lowerBound.distance(to:))
}

public func stride<T: Strideable>(
    over waypoints: [Waypoint<T>],
    by step: T.Stride = 1
)
-> [T]
{
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
