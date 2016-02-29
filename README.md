# Shelley

`Shelley` is most likely an **anti-pattern** of the network layer its built atop of, `ReactiveMoya`. It's a single `TargetType` for JSON requests.

#### Example

To make a JSON request, use `JSONRequest`. Here's an example:

```swift
// Edit the `baseURL`
CurrentAPIHost = "http://jsonplaceholder.typicode.com"

// Create a 'SignalProducer' for your request, and start it
JSONRequest("users").startWithNext {
  print($0)
}
```
<hr/>

### Example App

The project includes an OS X application which demonstrates using `Shelley` for inspecting JSON responses on any public URL (`GET`-only, for now):

![](http://cl.ly/2u2H0l2B0E3b/ShelleyApp.png)
