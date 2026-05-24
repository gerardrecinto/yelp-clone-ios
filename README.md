# Yelp Clone

![Swift](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![iOS 16+](https://img.shields.io/badge/iOS-16%2B-000000?logo=apple&logoColor=white)
![UIKit](https://img.shields.io/badge/UIKit-Auto%20Layout-blue)
![Yelp API](https://img.shields.io/badge/API-Yelp%20v2-FF1A1A)

![Demo](docs/assets/demo2.gif)

> Restaurant search app that authenticates against the Yelp v2 API using OAuth 1.0a via Mock data (API deprecated)| Layer | Technology |
|---|---|
| Language | Swift 6.0 |
| UI | UIKit, Auto Layout, UITableViewAutomaticDimension |
| Networking | URLSession (native)|
| API | Yelp API v2 (`/v2/search`) |
| Auth | OAuth 1.0a (BDBOAuth1Credential, BDBOAuth1RequestOperationManager) |
| Dependencies | CocoaPods |

## Architecture

`BusinessesViewController` owns the `UITableView` and acts as both data source and delegate. It calls `Business.searchWithTerm` — a thin static wrapper over `YelpClient.sharedInstance` — and stores results in a `businesses: [Business]` array before reloading the table. `Business` handles all JSON parsing in its `init(dictionary:)` and exposes a `businesses(array:)` class factory. `YelpClient` encapsulates all OAuth plumbing by subclassing `BDBOAuth1RequestOperationManager`, so authentication headers are injected at the `AFHTTPRequestSerializer` level before every request leaves the app.

## Key Implementation

**OAuth credential injection:** `YelpClient.init` calls `requestSerializer.saveAccessToken(_:)` with a `BDBOAuth1Credential` built from the pre-fetched token and secret. All subsequent GET calls through `AFHTTPRequestOperationManager` pick up those credentials automatically via the serializer.

**Distance formatting:** `Business.init` receives `distance` in meters as `NSNumber`, multiplies by `0.000621371`, and formats to two decimal places with `String(format: "%.2f mi", ...)` — no external library needed.

**Cell reuse safety:** `BusinessCell` uses the `business` property observer (`didSet`) to bind all labels and both image views synchronously, avoiding stale data when cells are dequeued from the reuse pool.

**Dual search paths:** `searchWithTerm(_:completion:)` delegates to the full `searchWithTerm(_:sort:categories:deals:completion:)` with `nil` optional arguments, keeping a single request path through `YelpClient`.

## Setup

```bash
git clone https://github.com/gerardrecinto/yelp-clone-ios.git
cd yelp-clone-ios
pod install
open yelpClone.xcworkspace
```

Add your Yelp API consumer key, consumer secret, access token, and access secret to `YelpClient.swift` before building.
