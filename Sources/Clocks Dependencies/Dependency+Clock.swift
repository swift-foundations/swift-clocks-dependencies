public import Clock_Primitives
public import Dependencies

private enum Key: Dependency.Key {}

extension Key {
    typealias Value = Clock.`Any`<Duration>
}

extension Key {
    static var liveValue: Clock.`Any`<Duration> {
        Clock.`Any`(Clock.Continuous())
    }

    static var testValue: Clock.`Any`<Duration> {
        Clock.`Any`(Clock.Immediate())
    }

    static var previewValue: Clock.`Any`<Duration> {
        Clock.`Any`(Clock.Immediate())
    }
}

extension Dependency.Values {

    public var clock: Clock.`Any`<Duration> {
        get { self[Key.self] }
        set { self[Key.self] = newValue }
    }
}
