import XCTest
import Clairvoyant
import ClairvoyantLogging
import Logging

final class ClairvoyantLoggingTests: XCTestCase {

    var temporaryDirectory: URL {
        if #available(macOS 13.0, iOS 16.0, watchOS 9.0, *) {
            return URL.temporaryDirectory
        } else {
            // Fallback on earlier versions
            return URL(fileURLWithPath: NSTemporaryDirectory())
        }
    }

    var logFolder: URL {
        temporaryDirectory.appendingPathComponent("logs")
    }

    func testBootstrap() async throws {
        let observer = MetricObserver(
            logFolder: logFolder,
            logMetricId: "observer.log",
            encoder: JSONEncoder(),
            decoder: JSONDecoder())
        let logging = MetricLogging(observer: observer)
        LoggingSystem.bootstrap(logging.backend)

        let entry = "It works"
        let result = "[INFO] \(entry)"
        let logger = Logger(label: "log.something")
        logger.info(.init(stringLiteral: entry))

        guard let metric = observer.getMetric(id: logger.label, type: String.self) else {
            XCTFail("No valid metric for logger")
            return
        }

        // Need to wait briefly here, since forwarding the log entry to the metric is done in an async context,
        // which would otherwise happen after trying to access the log data
        sleep(1)

        let last = await metric.lastValue()
        XCTAssertEqual(last?.value, result)

        let history = await metric.fullHistory()
        XCTAssertEqual(history.count, 1)
        XCTAssertEqual(history.first?.value ?? "", result)
    }
}
