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

import Dependencies_Test_Support
import Foundation
import Testing

@testable import Clocks_Dependencies

// Parallel-namespace suite: `Dependency.Values` is spelled through the
// generic `Dependency` wrapper, so an extension-hosted suite puts the
// @Test macro's emitted type path in a generic context. The top-level
// backtick-named suite is the sanctioned escape.
@Suite
struct `Dependency.Values Date Tests` {
    @Suite struct Unit {}
    @Suite struct Integration {}
}

extension `Dependency.Values Date Tests`.Unit {
    @Test
    func `the live key resolves to wall-clock time`() {
        @Dependency(\.date) var date

        let before = Date()
        let resolved = date()
        let after = Date()

        #expect(resolved >= before)
        #expect(resolved <= after)
    }

    @Test
    func `a constant generator returns its fixed date on every access`() {
        let frozen = Date(timeIntervalSince1970: 1_234_567_890)
        let generator = Date.Generator.constant(frozen)

        #expect(generator() == frozen)
        #expect(generator() == frozen)
    }
}

extension `Dependency.Values Date Tests`.Integration {
    @Test
    func `withDependencies overrides the date for the operation scope`() {
        let frozen = Date(timeIntervalSince1970: 0)

        withDependencies {
            $0.date = .constant(frozen)
        } operation: {
            @Dependency(\.date) var date

            #expect(date() == frozen)
        }
    }

    @Test(.dependency(\.date, .constant(Date(timeIntervalSince1970: 42))))
    func `the dependency trait overrides the date for a test`() {
        @Dependency(\.date) var date

        #expect(date() == Date(timeIntervalSince1970: 42))
    }
}
