#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

// MARK: - Darwin / Xcode Support
#if os(OSX)
    private var O_SYNC: CInt { fatalError("Linux only") }
#endif
