import XCTest
import Clairvoyant
import ClairvoyantLogging
import Logging
import MetricFileStorage

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
        let storage = try MultiFileStorage(
            folder: logFolder,
            encoderCreator: JSONEncoder.init,
            decoderCreator: JSONDecoder.init)
        let logging = MetricLogging(storage: storage)
        LoggingSystem.bootstrap(logging.backend)

        let entry = "It works"
        let result = "[INFO] \(entry)"
        let logger = Logger(label: "log.something")
        logger.info(.init(stringLiteral: entry))

        let metric = try storage.metric(id: logger.label, group: logging.group, type: String.self)
        
        let last = try metric.currentValue()
        XCTAssertEqual(last?.value, result)

        let history = try metric.history()
        XCTAssertEqual(history.count, 1)
        XCTAssertEqual(history.first?.value ?? "", result)
    }
}
