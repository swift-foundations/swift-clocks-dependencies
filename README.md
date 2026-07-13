# swift-clocks-dependencies

![Development Status](https://img.shields.io/badge/status-active--development-orange.svg)

A type-erased clock as a dependency value for [swift-dependencies](https://github.com/swift-foundations/swift-dependencies).

> The clocks × dependencies integration package: one home for time as a
> dependency. Consumers reach for `@Dependency(\.clock)` without their host
> package carrying clock wiring of its own.

## Overview

`import Clocks_Dependencies` provides `@Dependency(\.clock)` — a type-erased
`` Clock.`Any`<Duration> `` resolved through the standard dependency chain:

| Context | Resolves to | Behavior |
|---------|-------------|----------|
| Live    | `Clock.Continuous()` | real wall-clock time |
| Preview | `Clock.Immediate()`  | no suspension, instant resolution |
| Test    | `Clock.Immediate()`  | deterministic, no thread hops |

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-clocks-dependencies.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Clocks Dependencies", package: "swift-clocks-dependencies")
    ]
)
```

## Quick Start

```swift
import Clocks_Dependencies

@Dependency(\.clock) var clock
try await clock.sleep(for: .seconds(1))
```

Override in tests for controlled time:

```swift
@Test(.dependency(\.clock, Clock.`Any`(Clock.Test())))
func timedFeature() async { ... }
```

## License

Licensed under the [Apache License, Version 2.0](LICENSE.md).
