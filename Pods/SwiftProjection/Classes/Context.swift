//
//  Context.swift
//  PROJ.Swift
//
//  Created by Will Ross on 3/9/18.
//  Copyright © 2018 Will Ross. All rights reserved.
//

import Foundation
import Threadly

internal let projContext = ThreadLocal(create: { ProjectionContext() })

/**
 An internal class that handles [PJ_CONTEXT][pj_ctx] lifetime management.
 It's available as an automatically available thread-local through the
 `projContext` global within the SwiftProjection module.

 [pj_ctx]: http://proj4.org/development/reference/datatypes.html#c.PJ_CONTEXT
 */
internal class ProjectionContext {
    // Wrapping the context in a Swift class to get memory management
    internal let context: OpaquePointer

    /**
     The current error, if any, for this context.

     - Returns: `nil` if there is no error, a `ProjSwiftError.LibraryError` otherwise.
     */
    public var currentError: ProjectionError? {
        let errorNumber = proj_context_errno(context)
        guard errorNumber != 0 else {
            return nil
        }
        return ProjectionError.LibraryError(code: errorNumber)
    }

    /**
     Creates a `PJ_CONTEXT` and sets the context to use the alternative API that looks in the framework bundle for the
     PROJ resource data files.
     */
    init() {
        context = proj_context_create()
        // NOTE: Deprecated API usage; pj_ctx_set_fileapi
        // A replacement for the fileapi is planned for before pj_ctx_set_fileapi is removed.
        pj_ctx_set_fileapi(context, get_bundle_fileapi())
        // Not checking for errors here, as if this is throwing error, we have larger problems
        // TODO: Add logging for errors here
    }

    deinit {
        proj_context_destroy(context)
    }
}
