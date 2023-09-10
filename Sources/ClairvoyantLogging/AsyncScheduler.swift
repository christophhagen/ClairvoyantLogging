import Foundation

/**
 An asynchronous function for an `AsyncScheduler`
 */
public typealias AsyncFunction = () async throws -> Void

/**
 The type to provide asynchronous task scheduling.

 In Swift, normal `Task`s can be used:

 ```
 Task {
     try await asyncOperation() // Updates the metric
 }
 ```

 Other contexts, such as when using `SwiftNIO` event loops, may need a different type of scheduling.
 */
public protocol AsyncScheduler {

    /**
     Schedule an async operation.
     - Parameter schedule: The asynchronous function to run
     */
    func schedule(asyncJob: @escaping AsyncFunction)
}

struct AsyncTaskScheduler: AsyncScheduler {

    func schedule(asyncJob: @escaping AsyncFunction) {
        Task {
            try await asyncJob()
        }
    }
}

