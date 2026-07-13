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
import Testing

@testable import Clocks_Dependencies

extension Dependency.Values {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension Dependency.Values.Test.Unit {
    @Test
    func `test context resolves the clock without suspension`() async throws {
        @Dependency(\.clock) var clock

        let wall = ContinuousClock()
        let start = wall.now
        try await clock.sleep(for: .seconds(60))
        let elapsed = start.duration(to: wall.now)

        #expect(elapsed < .seconds(5))
    }

    @Test
    func `withDependencies overrides the clock for the operation scope`() {
        let test = Clock.Test()

        withDependencies {
            $0.clock = Clock.`Any`(test)
        } operation: {
            @Dependency(\.clock) var clock

            let before = clock.now
            test.advance(by: .seconds(5))
            let after = clock.now

            #expect(before.duration(to: after) == .seconds(5))
        }
    }
}

extension Dependency.Values.Test.`Edge Case` {
    @Test
    func `sleeping for a zero duration returns immediately`() async throws {
        @Dependency(\.clock) var clock

        var completed = false
        try await clock.sleep(for: .zero)
        completed = true

        #expect(completed)
    }
}

extension Dependency.Values.Test.Integration {
    @Test(.dependency(\.clock, Clock.`Any`(Clock.Immediate())))
    func `the dependency trait overrides the clock for a test`() async throws {
        @Dependency(\.clock) var clock

        let wall = ContinuousClock()
        let start = wall.now
        try await clock.sleep(for: .seconds(60))
        let elapsed = start.duration(to: wall.now)

        #expect(elapsed < .seconds(5))
    }

    @Test
    func `a sleeper suspended on the key's clock resumes when the test clock runs`() async throws {
        let test = Clock.Test()

        try await withDependencies {
            $0.clock = Clock.`Any`(test)
        } operation: {
            @Dependency(\.clock) var clock
            let resolved = clock

            async let sleeper: Bool = {
                try await resolved.sleep(for: .seconds(3))
                return true
            }()

            // Wait until the sleeper has actually suspended on the test
            // clock (checkSuspension throws once an active sleep exists),
            // then drive the clock past every scheduled deadline.
            while (try? test.checkSuspension()) != nil {
                await Task.yield()
            }
            test.run()

            let resumed = try await sleeper
            #expect(resumed)
        }
    }
}
