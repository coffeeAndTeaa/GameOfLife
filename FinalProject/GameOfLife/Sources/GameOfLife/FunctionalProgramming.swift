//
//  FunctionalProgramming.swift
//

/*:
 Handy functions for composition
 */
public func identity<T>(_ t: T) -> T { t }

public func curry<A, B, C>(
    _ function: @escaping (A, B) -> C
) -> (A) -> (B) -> C {
    { (a: A) -> (B) -> C in
        { (b: B) -> C in
            function(a, b)
        }
    }
}

public func nest<T, U, V>(
    _ f1: ((V) throws -> [T]) throws -> [[T]],       // signature of map
    _ f2: @escaping ((U) throws -> T) throws -> [T], // Signature of map
    _  g: @escaping (V) -> (U) throws -> T
) throws -> [[T]] {
    try f1 { try f2(g($0)) }
}

public extension Array {
    init<T>(
        _ rows: Int,
        _ cols: Int,
        _ initializer: @escaping (Int, Int) -> T
    ) where Element == [T] {
        self = try! nest((0 ..< rows).lazy.map, (0 ..< cols).lazy.map, curry(initializer))
    }
}
