//
//  FancyLogger.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation

class FancyLogger {

    enum Severity: Comparable {
        static func < (lhs: FancyLogger.Severity, rhs: FancyLogger.Severity) -> Bool {
            switch (lhs, rhs) {
            case (.error, .warning), (.error, .notice), (.error, .info):
                return false
            case (.warning, .notice), (.warning, .info):
                return false
            case  (.notice, .info):
                return false
            default:
                return true
            }
        }

        /// The lowest severity of log message.  These occur during normal operation in the happy path.
        case info

        /// The second-lowest severity of log message.  These occur during normal operation on expected edge cases.
        case notice

        /// The second-highest severity of log message.  These may result in strange-looking behavior, but can be worked around or ignored.
        case warning

        /// The highest severity of log message.  These probably merit a crash because there's no reasonable way to continue.
        case error

        func prefix() -> String {
            switch self {
            case .info:
                return "ⓘ INFO:"
            case .notice:
                return "🛂 NOTICE:"
            case .warning:
                return "⚠️ WARNING:"
            case .error:
                return "⛔️ ERROR:"
            }
        }
    }

    struct Item {
        var severity: Severity
        var message: String
    }

    static func log(_ item: Item) {
        if item.severity > minimumConsoleSeverity {
            print("\(item.severity.prefix())  \(item.message)")
        } else {
            // print("didn't think \(item.severity) is higher than \(minimumConsoleSeverity)")
        }
    }

    // only items with a higher severity than this will be logged to the console
    static var minimumConsoleSeverity: Severity = .error

    static var debugAnalytics = false

    static func analytics(_ message: String) {
        if debugAnalytics {
            print("🔎 ANALYTICS: \(message)")
        }
    }

    static func info(_ message: String) {
        log(Item(severity: .info, message: message))
    }

    static func notice(_ message: String) {
        log(Item(severity: .notice, message: message))
    }

    static func warning(_ message: String) {
        log(Item(severity: .warning, message: message))
    }

    static func error(_ message: String) {
        log(Item(severity: .error, message: message))
    }
}
