// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-clocks-dependencies open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-clocks-dependencies
// project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Clock_Primitives
public import Dependencies

// MARK: - Clock Dependency Key

/// Dependency key providing a type-erased clock.
///
/// Resolution chain:
/// - **Live**: `Clock.Continuous()` — real wall-clock time
/// - **Preview**: `Clock.Immediate()` — no suspension, instant resolution
/// - **Test**: `Clock.Immediate()` — deterministic, no thread hops
///
/// Override in tests for controlled time:
/// ```swift
/// @Test(.dependency(\.clock, Clock.`Any`(Clock.Test())))
/// func testTimedFeature() async { ... }
/// ```
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

// MARK: - Dependency.Values Extension

extension Dependency.Values {
    /// A type-erased clock for timing operations.
    ///
    /// In production, resolves to `Clock.Continuous`. In tests and previews,
    /// resolves to `Clock.Immediate` (no suspension, deterministic).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// @Dependency(\.clock) var clock
    /// try await clock.sleep(for: .seconds(1))
    /// ```
    ///
    /// ## Test Override
    ///
    /// ```swift
    /// withDependencies {
    ///     $0.clock = Clock.`Any`(Clock.Test())
    /// } operation: {
    ///     // clock.sleep resolves via Clock.Test
    /// }
    /// ```
    public var clock: Clock.`Any`<Duration> {
        get { self[Key.self] }
        set { self[Key.self] = newValue }
    }
}
