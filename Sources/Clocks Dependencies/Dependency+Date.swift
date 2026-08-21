public import Dependencies
public import Foundation

private enum Key: Dependency.Key {}

extension Key {
    typealias Value = Date.Generator
}

extension Key {
    static var liveValue: Date.Generator {
        Date.Generator { Date() }
    }
}

extension Dependency.Values {

    public var date: Date.Generator {
        get { self[Key.self] }
        set { self[Key.self] = newValue }
    }
}
