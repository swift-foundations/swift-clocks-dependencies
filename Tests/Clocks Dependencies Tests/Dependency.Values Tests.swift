import Dependencies_Test_Support
import Testing

@testable import Clocks_Dependencies

@Suite
struct `Dependency.Values Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Dependency.Values Tests`.Unit {
    @Test
    func `test mode resolves the clock to an immediate clock`() async throws {

        try await withDependencies(mode: .test) {
            @Dependency(\.clock) var clock

            let wall = ContinuousClock()
            let start = wall.now
            try await clock.sleep(for: .seconds(2))
            let elapsed = start.duration(to: wall.now)

            #expect(elapsed < .seconds(1))
        }
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

extension `Dependency.Values Tests`.`Edge Case` {
    @Test
    func `sleeping for a zero duration returns immediately`() async throws {
        @Dependency(\.clock) var clock

        var completed = false
        try await clock.sleep(for: .zero)
        completed = true

        #expect(completed)
    }
}

extension `Dependency.Values Tests`.Integration {
    @Test(.dependency(\.clock, Clock.`Any`(Clock.Immediate())))
    func `the dependency trait overrides the clock for a test`() async throws {
        @Dependency(\.clock) var clock

        let wall = ContinuousClock()
        let start = wall.now
        try await clock.sleep(for: .seconds(2))
        let elapsed = start.duration(to: wall.now)

        #expect(elapsed < .seconds(1))
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

            func isSuspended() -> Bool {
                do throws(Clock.Test.Suspension.Error) {
                    try test.checkSuspension()
                    return false
                } catch {
                    return true
                }
            }

            while !isSuspended() {
                await Task.yield()
            }
            test.run()

            let resumed = try await sleeper
            #expect(resumed)
        }
    }
}
