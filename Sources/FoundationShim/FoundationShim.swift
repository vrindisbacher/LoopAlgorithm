// FoundationShim.swift
// Provides Foundation-free replacements for the types LoopAlgorithm needs
// when compiling for WebAssembly.
//
// NO outer #if guard — this module is only imported on wasm32 targets.

// MARK: - TimeInterval

public typealias TimeInterval = Double

extension TimeInterval {
    public init(minutes: Double) { self = minutes * 60.0 }
    public init(hours: Double) { self = hours * 3600.0 }

    public static func minutes(_ m: Double) -> TimeInterval { m * 60.0 }
    public static func hours(_ h: Double) -> TimeInterval { h * 3600.0 }

    public var minutes: Double { self / 60.0 }
    public var hours: Double { self / 3600.0 }
}

// MARK: - Date

public struct Date: Sendable, Comparable, Equatable, Hashable {
    public var timeIntervalSinceReferenceDate: TimeInterval

    public init() {
        self.timeIntervalSinceReferenceDate = 0
    }

    public init(timeIntervalSinceReferenceDate: TimeInterval) {
        self.timeIntervalSinceReferenceDate = timeIntervalSinceReferenceDate
    }

    public init(timeIntervalSince1970: TimeInterval) {
        // Foundation reference date (2001-01-01) is 978307200 seconds after Unix epoch
        self.timeIntervalSinceReferenceDate = timeIntervalSince1970 - 978_307_200
    }

    public var timeIntervalSince1970: TimeInterval {
        timeIntervalSinceReferenceDate + 978_307_200
    }

    public func timeIntervalSince(_ other: Date) -> TimeInterval {
        timeIntervalSinceReferenceDate - other.timeIntervalSinceReferenceDate
    }

    public func addingTimeInterval(_ interval: TimeInterval) -> Date {
        Date(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate + interval)
    }

    public static func < (lhs: Date, rhs: Date) -> Bool {
        lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
    }

    public static var distantPast: Date {
        Date(timeIntervalSinceReferenceDate: -63_113_904_000)
    }

    public static var distantFuture: Date {
        Date(timeIntervalSinceReferenceDate: 63_113_904_000)
    }

    public func dateFlooredToTimeInterval(_ interval: TimeInterval) -> Date {
        let ref = timeIntervalSinceReferenceDate
        let floored = (ref / interval).rounded(.down) * interval
        return Date(timeIntervalSinceReferenceDate: floored)
    }

    public func dateCeiledToTimeInterval(_ interval: TimeInterval) -> Date {
        let ref = timeIntervalSinceReferenceDate
        let ceiled = (ref / interval).rounded(.up) * interval
        return Date(timeIntervalSinceReferenceDate: ceiled)
    }
}

// MARK: - Date Arithmetic Operators

extension Date {
    public static func - (lhs: Date, rhs: TimeInterval) -> Date {
        lhs.addingTimeInterval(-rhs)
    }

    public static func + (lhs: Date, rhs: TimeInterval) -> Date {
        lhs.addingTimeInterval(rhs)
    }

    public static func += (lhs: inout Date, rhs: TimeInterval) {
        lhs = lhs.addingTimeInterval(rhs)
    }

    public static func -= (lhs: inout Date, rhs: TimeInterval) {
        lhs = lhs.addingTimeInterval(-rhs)
    }
}

// MARK: - DateInterval

public struct DateInterval: Sendable, Equatable {
    public var start: Date
    public var end: Date

    public var duration: TimeInterval {
        end.timeIntervalSince(start)
    }

    public init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }

    public init(start: Date, duration: TimeInterval) {
        self.start = start
        self.end = start.addingTimeInterval(duration)
    }

    public func contains(_ date: Date) -> Bool {
        date >= start && date <= end
    }

    public func intersection(with other: DateInterval) -> DateInterval? {
        let newStart = start > other.start ? start : other.start
        let newEnd = end < other.end ? end : other.end
        guard newStart < newEnd else { return nil }
        return DateInterval(start: newStart, end: newEnd)
    }
}

// MARK: - ComparisonResult

public enum ComparisonResult: Int, Sendable {
    case orderedAscending = -1
    case orderedSame = 0
    case orderedDescending = 1
}

// MARK: - NSLocalizedString replacement

public func NSLocalizedString(_ key: String, comment: String) -> String {
    return key
}

// MARK: - C Math Functions

@_silgen_name("pow")
private func _c_pow(_ x: Double, _ y: Double) -> Double

@_silgen_name("powf")
private func _c_powf(_ x: Float, _ y: Float) -> Float

public func pow(_ x: Double, _ y: Double) -> Double { _c_pow(x, y) }
public func pow(_ x: Float, _ y: Float) -> Float { _c_powf(x, y) }

@_silgen_name("sqrt")
private func _c_sqrt(_ x: Double) -> Double

@_silgen_name("sqrtf")
private func _c_sqrtf(_ x: Float) -> Float

public func sqrt(_ x: Double) -> Double { _c_sqrt(x) }
public func sqrt(_ x: Float) -> Float { _c_sqrtf(x) }

@_silgen_name("floor")
private func _c_floor(_ x: Double) -> Double

@_silgen_name("floorf")
private func _c_floorf(_ x: Float) -> Float

public func floor(_ x: Double) -> Double { _c_floor(x) }
public func floor(_ x: Float) -> Float { _c_floorf(x) }

@_silgen_name("ceil")
private func _c_ceil(_ x: Double) -> Double

@_silgen_name("ceilf")
private func _c_ceilf(_ x: Float) -> Float

public func ceil(_ x: Double) -> Double { _c_ceil(x) }
public func ceil(_ x: Float) -> Float { _c_ceilf(x) }

@_silgen_name("exp")
private func _c_exp(_ x: Double) -> Double

@_silgen_name("expf")
private func _c_expf(_ x: Float) -> Float

public func exp(_ x: Double) -> Double { _c_exp(x) }
public func exp(_ x: Float) -> Float { _c_expf(x) }

@_silgen_name("log")
private func _c_log(_ x: Double) -> Double

@_silgen_name("logf")
private func _c_logf(_ x: Float) -> Float

public func log(_ x: Double) -> Double { _c_log(x) }
public func log(_ x: Float) -> Float { _c_logf(x) }

@_silgen_name("fabs")
private func _c_fabs(_ x: Double) -> Double

@_silgen_name("fabsf")
private func _c_fabsf(_ x: Float) -> Float

public func fabs(_ x: Double) -> Double { _c_fabs(x) }
public func fabs(_ x: Float) -> Float { _c_fabsf(x) }

@_silgen_name("round")
private func _c_round(_ x: Double) -> Double

@_silgen_name("roundf")
private func _c_roundf(_ x: Float) -> Float

public func round(_ x: Double) -> Double { _c_round(x) }
public func round(_ x: Float) -> Float { _c_roundf(x) }
