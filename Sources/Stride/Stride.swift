
public enum Waypoint<T: Strideable> {
    case low(T)
    case high(T)
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
