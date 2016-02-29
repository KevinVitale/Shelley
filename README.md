# Shelley

`Shelley` is most likely an **anti-pattern** of the network layer its built atop of, `ReactiveMoya`. It's a single `TargetType` for JSON requests.

#### Dependencies

You will need to use `Carthage` to build dependencies.

```bash
$ carthage bootstrap
```

#### Example

To make a JSON request, use `JSONRequest`. Here's an example:

```swift
// Edit the `baseURL`
CurrentAPIHost = "http://jsonplaceholder.typicode.com"

// Create a 'SignalProducer' for your request, and start it
JSONRequest("users")
  .startWithNext {
    print($0) // Executed 10 times; once for each 'user'
}
```

<hr/>

##### JSONRequest

`JSONRequest` is a function which generates `JSONTarget<T>`.

##### JSONTarget<T>

`JSONTarget<T>` is a generic struct that encapsulates `JSONEndpoint`, an internal `TargetType` adopter. Its the most interesting part of the "framework", because it adopts `SignalProducer`.

##### SignalProducerType Extension

`JSONTarget<T>.producer` uses an extension added to `SignalProducerType`, specifically `mapJSONResponse<T>()`, to map JSON responses in a producer created using `SignalProducer(values: [T])`.

##### JSONEndpoint

`JSONEndpoint` is an enum with a single case, `Request`. It adopts `TargetType` (from `Moya`).

<hr/>

### Example App

The project includes an OS X application which demonstrates using `Shelley` for inspecting JSON responses on any public URL (`GET`-only, for now):

![](http://cl.ly/2u2H0l2B0E3b/ShelleyApp.png)
