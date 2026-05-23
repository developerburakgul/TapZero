//
//  GA4EventSanitizer.swift
//  TapZero
//

import Foundation

enum GA4EventSanitizer {
    // MARK: - Event Name

    /// GA4 event name rules:
    /// - Only letters, numbers, underscores
    /// - Must start with a letter
    /// - Max 40 characters
    static func sanitizeEventName(_ name: String) -> String {
        var sanitized = name
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")

        sanitized = sanitized.filter { $0.isLetter || $0.isNumber || $0 == "_" }

        if let first = sanitized.first, !first.isLetter {
            sanitized = "e_" + sanitized
        }

        if sanitized.count > 40 {
            sanitized = String(sanitized.prefix(40))
        }

        return sanitized
    }

    // MARK: - Parameters

    /// GA4 parameter rules:
    /// - Max 25 custom parameters per event
    /// - Parameter name max 40 characters
    /// - Parameter string value max 100 characters
    static func sanitizeParameters(_ parameters: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        for (key, value) in parameters.prefix(25) {
            let sanitizedKey = sanitizeParameterName(key)
            let sanitizedValue = sanitizeParameterValue(value)
            result[sanitizedKey] = sanitizedValue
        }
        return result
    }

    static func sanitizeParameterName(_ name: String) -> String {
        var sanitized = name
            .replacingOccurrences(of: " ", with: "_")
            .filter { $0.isLetter || $0.isNumber || $0 == "_" }

        if sanitized.count > 40 {
            sanitized = String(sanitized.prefix(40))
        }

        return sanitized
    }

    static func sanitizeParameterValue(_ value: Any) -> Any {
        if let stringValue = value as? String, stringValue.count > 100 {
            return String(stringValue.prefix(100))
        }
        return value
    }
}
