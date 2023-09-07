# ClairvoyantLogging

Useful extensions for using [swift-log](https://github.com/apple/swift-log) together with [Clairvoyant](https://github.com/christophhagen/Clairvoyant).

## Usage

Clairvoyant can be used as a logging backend for [swift-log](https://github.com/apple/swift-log), so that all logs are made available as `String` metrics.
To forward logs as metrics, add a dependency for [ClairvoyantLogging](https://github.com/christophhagen/ClairvoyantLogging) and import the required module:

```swift
import Clairvoyant
import ClairvoyantLogging
```

Now, simply set an observer as the backend:

```swift
let observer = MetricObserver(...)
let logging = MetricsLogging(observer: observer)
LoggingSystem.bootstrap(logging.backend)
```

Each logging entry will then be timestamped and added to a metric with the same `ID` as the logger `label`.

```swift
let logger = Logger(label: "my.log")
logger.info("It works!")
```

The logging metrics are made available over the API in the same way as other metrics, and can also be accessed directly.

```swift
let metric = observer.getMetric(id: "my.log", type: String.self)
```

It's possible to change the logging format by setting the `loggingFormat` property on `MetricLogging` before creating a logger.
The property applies to each new logger, but changes are not propagated to existing ones.

```swift
logging.outputFormat = .full
```
