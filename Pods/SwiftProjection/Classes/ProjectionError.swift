//
//  Error.swift
//  Pods
//
//  Created by Will Ross on 3/16/18.
//

/**
 Errors thrown by SwiftProjection
 */
public enum ProjectionError: Error, CustomStringConvertible {
    /// Errors initiated from within PROJ. `code` is the value from `proj_errno`.
    case LibraryError(code: Int32)

    /// For `LibraryError`s, the string description from PROJ for the error code is used.
    public var description: String {
        // NOTE: Deprecated API usage; pj_strerrno
        // Once PROJ 5.1.0 is released, pj_strerrno can be replaced with proj_errno_string (they have same signature)
        switch self {
        case let .LibraryError(code):
            var message = "(no error description found)"
            if let errorDescription = pj_strerrno(code) {
                if let projDescription = String(utf8String: errorDescription) {
                    message = projDescription
                }
            }
            return "PROJ error \(code): \(message)"
        }
    }
}
