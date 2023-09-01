# ClairvoyantLogging

Useful extensions for using [swift-log](https://github.com/apple/swift-log) together with [Clairvoyant](https://github.com/christophhagen/Clairvoyant).

The package provides a `MetricLogging` object, so you can do:

```swift
let logging = MetricLogging(...)
LoggingSystem.bootstrap(logging.backend)
```

For more information, see the [documentation](https://github.com/christophhagen/Clairvoyant#usage-with-swift-log) of the [Clairvoyant framework](https://github.com/christophhagen/Clairvoyant).

