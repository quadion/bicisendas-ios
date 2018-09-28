//
//  Projection.swift
//  PROJ.Swift
//
//  Created by Will Ross on 3/9/18.
//  Copyright © 2018 Will Ross. All rights reserved.
//

import Foundation

/**
 Transforms coordinates from one reference system to another. A Swift class is used primarily for the deinitializers to
 ensure that the `PJ` structure is freed appropriately.
 */
public class Projection: CustomDebugStringConvertible {
    /// A pointer to a `PJ` structure created by proj_create
    private let projection: OpaquePointer

    /// Private lazy property for the `PJ_PROJ_INFO` for this instance's `projection`
    private lazy var info: PJ_PROJ_INFO = {
        self.updateContext()
        return proj_pj_info(self.projection)
    }()

    /// The direction this Projection uses for `transform(...)`
    private let transformDirection: PJ_DIRECTION

    /// A `Projection` that performs the inverse of this Projection.
    /// If this projection does not have an inverse, this property is `nil`.
    public lazy var inverse: Projection? = {
        guard hasInverse else {
            return nil
        }
        let isForward = transformDirection == PJ_FWD
        return try? Projection(projection: self, isForward: !isForward)
    }()

    // MARK: - Projection Info

    /// The type of projection this is, ex: the `foo` in `proj=foo`.
    public var id: String {
        return String(utf8String: info.id)!
    }

    /// A long description of the projection.
    public var description: String {
        return String(utf8String: info.description)!
    }

    /// A normalized version of the PROJ4 definition. It removes '+' signs and expands `init` definitions.
    public var definition: String {
        return String(utf8String: info.definition)!
    }

    /// True this projection is invertible.
    public var hasInverse: Bool {
        return info.has_inverse == 1
    }

    /// Expected accuracy. If this projections does not provide it, this value is `nil`.
    public var accuracy: Double? {
        guard info.accuracy != -1 else {
            return nil
        }
        return info.accuracy
    }

    /// True if the input is supposed to be angular (for example, converting from geodetic to cartesian coordinates).
    public lazy var inputIsAngular: Bool = {
        self.updateContext()
        return proj_angular_input(projection, transformDirection) == 1
    }()

    /// True if the output is supposed to be angular (for example, converting from cartesian to geodetic coordinates).
    public lazy var outputIsAngular: Bool = {
        self.updateContext()
        return proj_angular_output(projection, transformDirection) == 1
    }()

    // MARK: - Debugging and Errors

    public var debugDescription: String {
        return definition
    }

    /// The current error for the current PROJ context, as a `ProjectionError.LibraryError`.
    /// If there is no error set, the value is `nil`.
    public var currentError: ProjectionError? {
        // Do _not_ change the current context for the projection, it's already been set by whatever caused the error.
        let errorNumber = proj_errno(projection)
        guard errorNumber != 0 else {
            return nil
        }
        return ProjectionError.LibraryError(code: errorNumber)
    }

    // MARK: - Pipeline introspection

    /// Convenience property for if the projection is a pipeline.
    internal var isPipeline: Bool {
        return id == "pipeline"
    }

    /// Splits a pipeline projection definition into the pipeline globals and steps.
    /// The first element is the globals (including `proj=pipeline`).
    /// Subsequent elements are for each step in the pipeline, with `step` omitted (but this may change in the future).
    private var pipeline: [String] {
        guard isPipeline else {
            return [definition]
        }
        let words = definition.split(separator: " ")
        var steps: [String] = []
        var currentStep = ""
        for word in words {
            if word == "step" {
                // The last character is a space, trim it off
                currentStep = String(currentStep.dropLast())
                steps.append(currentStep)
                currentStep = ""
            } else {
                currentStep.append(contentsOf: word)
                currentStep.append(" ")
            }
        }
        // Append the last step
        currentStep = String(currentStep.dropLast())
        steps.append(currentStep)
        return steps
    }

    /// Convenience property for the global settings in a pipeline.
    /// If the projection is not a pipeline, the value is just the normal definition.
    internal var pipelineGlobals: String {
        guard isPipeline else {
            return definition
        }
        return pipeline[0]
    }

    /// Convenience property for the steps in a pipeine.
    /// If the projection is not a pipeline, the value is an empty array.
    internal var pipelineSteps: [String] {
        guard isPipeline else {
            return []
        }
        return Array(pipeline.suffix(from: 1))
    }

    // MARK: - Initializers

    /**
     Private, designated initializer that provides access to specifying which direction the projection is. This is used
     to invert a projection.

     - Parameters:
       - projString: a definition of a projection like that given in the [PROJ manual][proj-usage].
       - isForward: whether or not a projections is a forward projection or an inverse projection.
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library.

     [proj-usage]: http://proj4.org/usage/index.html
     */
    private init(projString: String, isForward: Bool) throws {
        let context = projContext.inner.value
        self.transformDirection = isForward ? PJ_FWD : PJ_INV
        if let pj = proj_create(context.context, projString) {
            projection = pj
        } else {
            // There's an error, projection initialization failed.
            throw context.currentError!
        }
    }

    /**
     Initializes a `Projection` using a PROJ-style definition. This is a forward transformation, to get an inverse
     transform, access the `inverse` property of a `Projection`.

     - Parameter projString: a definition of a projection like that given in the [PROJ manual][proj-usage].
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library.

     [proj-usage]: http://proj4.org/usage/index.html
     */
    public convenience init(projString: String) throws {
        try self.init(projString: projString, isForward: true)
    }

    /**
     Initializes a `Projection` using a well known identifier available in a bundled data file. The standard PROJ data
     files are bundles into the framework, including the EPSG database.

     - Parameter identifier: A datafile and identifier, like that used with the [`init` PROJ parameter][init]. For
     example: `epsg:3857`.
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library.

     [init]: http://proj4.org/resource_files.html#init-files
     */
    public convenience init(identifier: String) throws {
        try self.init(projString: "+init=\(identifier)")
    }

    /**
     Private initializer that creates a new `Projection` from an existing one. Specifically used when creating inverted
     `Projection`s.

     - Parameters:
       - projection: an existing `Projection` to use as the source.
       - isForward: whether or not a projections is a forward projection or an inverse projection.
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library.
     */
    private convenience init(projection: Projection, isForward: Bool) throws {
        try self.init(projString: projection.definition, isForward: isForward)
    }

    /// The real reason `Projection` is a `class` instead of a `struct` is so we an use `deinit` to clean up the
    /// `PJ` structure.
    deinit {
        proj_destroy(projection)
    }

    // MARK: - Transforms

    /**
     Transform a single coordinate with this projection.

     - SeeAlso: [PROJ: Coordinate Transformation][proj-transform]
     - Parameter coordinate: The coordinate to transform.
     - Returns: A `ProjectionCoordinate` with the new coordinates.
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library.

     [proj-transform]: http://proj4.org/development/reference/functions.html#coordinate-transformation
     */
    public func transform(coordinate convertibleCoordinate: ConvertibleCoordinate) throws -> ProjectionCoordinate {
        updateContext()
        let coordinate = convertibleCoordinate.getCoordinate()
        let projCoordinate = coordinate.getProjCoordinate()
        let transformed = proj_trans(projection, transformDirection, projCoordinate)
        if let error = currentError {
            throw error
        }
        return ProjectionCoordinate(transformed)
    }

    /**
     Transform multiple coordinates with this projection. Currently this method does a fairly naive map of the given
     coordinates with `transform(coordinate:)`, but there's an opportunity for possible speedups later on by using
     `proj_trans_array` or `proj_trans_generic`.

     - SeeAlso: [PROJ: Coordinate Transformation][proj-transform]
     - Parameter coordinates: A sequence of `ConvertibleCoordinate`s.
     - Returns: An array of `ProjectionCoordinate`s with the new coordinates.
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library.

     [proj-transform]: http://proj4.org/development/reference/functions.html#coordinate-transformation
     */
    public func transform(coordinates: AnySequence<ConvertibleCoordinate>) throws -> [ProjectionCoordinate] {
        return try coordinates.map {
            try self.transform(coordinate: $0)
        }
    }

    // MARK: - Constructing Pipelines

    /**
     Converts a normal `Projection` into a pipeline projection with a single step.
     If this instance is already a pipeline, this method returns `self`.

     - SeeAlso: [PROJ: The pipeline operator][proj-pipeline]
     - Returns: A `Projection` that uses a [pipeline][proj-pipeline].
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library.

     [proj-pipeline]: http://proj4.org/operations/pipeline.html
     */
    public func asPipeline() throws -> Projection {
        if isPipeline {
            return self
        }
        var pipelineDefinition = "proj=pipeline step \(definition)"
        if transformDirection == PJ_INV {
            pipelineDefinition.append(" inv")
        }
        return try Projection(projString: pipelineDefinition)
    }

    /**
     Append a step given as a PROJ definition to a pipeline operation.

     If this instance is not a pipeline already, a new one that is a pipeline will be created and returned.

     - SeeAlso: [PROJ: The pipeline operator][proj-pipeline]
     - Parameter projString: The definition of a step without the `step` parameter. The `inv` parameter *is* allowed.
     - Returns: A new `Projection` instance with the existing steps and the new step.
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library. An example of this is if
     you try to add a pipeline within a pipeline. This is currently unsupported (see
     [Rules for Pipelines][proj-pipeline]).

     [proj-pipeline]: http://proj4.org/operations/pipeline.html
     */
    public func appendStep(projString: String) throws -> Projection {
        guard isPipeline else {
            return try asPipeline().appendStep(projString: projString)
        }
        let newDefinition = "\(definition) step \(projString)"
        return try Projection(projString: newDefinition)
    }

    /**
     Append an existing `Projection` as a step to a pipeline operation.

     If this instance is not a pipeline already, a new one that is a pipeline will be created and returned.

     - SeeAlso: [PROJ: The pipeline operator][proj-pipeline]
     - Parameter projString: The definition of a step without the `step` parameter. The `inv` parameter *is* allowed.
     - Returns: A new `Projection` instance with the existing steps and the new step.
     - Throws: a `ProjectionError.LibraryError` when there's an error within the PROJ library. An example of this is if
     you try to add a pipeline within a pipeline. This is currently unsupported (see
     [Rules for Pipelines][proj-pipeline]).

     [proj-pipeline]: http://proj4.org/operations/pipeline.html
     */
    public func appendStep(projection: Projection) throws -> Projection {
        return try self.appendStep(projString: projection.definition)
    }

    // MARK: - Misc

    /**
     This method should be called before using any of the PROJ library functions. It updates the thread context for the
     `projection` structure, ensuring that erorr handling is handled appropriately.
     */
    private func updateContext() {
        // NOTE: Deprecated API usage; proj_context_set is internal
        pj_set_ctx(projection, projContext.inner.value.context)
        resetError()
    }

    /**
     Resets the error state in the current context through the `projection` structure.
     */
    private func resetError() {
        proj_errno_reset(projection)
    }
}
