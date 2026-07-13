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

// Re-exports both halves of the integration so `import Clocks_Dependencies`
// is a self-contained surface: the clock vocabulary and the dependency system
// both appear in the vended API.

@_exported public import Clock_Primitives
@_exported public import Dependencies
