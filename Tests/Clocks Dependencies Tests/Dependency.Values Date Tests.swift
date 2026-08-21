import Dependencies_Test_Support
import Foundation
import Testing

@testable import Clocks_Dependencies

@Suite
struct `Dependency.Values Date Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
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
