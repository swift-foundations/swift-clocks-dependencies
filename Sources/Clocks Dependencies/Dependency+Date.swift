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

public import Dependencies
public import Foundation

// MARK: - Date Dependency Key

/// Dependency key providing the current wall-clock date.
///
/// Resolution chain:
/// - **Live**: `Date()` — real wall-clock time
/// - **Preview**/**Test**: defaults to `liveValue`; override explicitly for
///   deterministic time:
///
/// ```swift
/// @Test(.dependency(\.date, .constant(Date(timeIntervalSince1970: 0))))
/// func timedFeature() { ... }
/// ```
private enum Key: Dependency.Key {}

extension Key {
    typealias Value = Date.Generator
}

extension Key {
    static var liveValue: Date.Generator {
        Date.Generator { Date() }
    }
}

// MARK: - Dependency.Values Extension

extension Dependency.Values {
    /// A controllable source of the current date.
    ///
    /// In production, resolves to the real wall-clock `Date()`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// @Dependency(\.date) var date
    /// let now = date()
    /// ```
    ///
    /// ## Test Override
    ///
    /// ```swift
    /// withDependencies {
    ///     $0.date = .constant(Date(timeIntervalSince1970: 1_234_567_890))
    /// } operation: {
    ///     // date() resolves to the fixed instant
    /// }
    /// ```
    public var date: Date.Generator {
        get { self[Key.self] }
        set { self[Key.self] = newValue }
    }
}
