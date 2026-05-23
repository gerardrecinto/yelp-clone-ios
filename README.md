# Yelp Clone

![Swift](https://img.shields.io/badge/Swift-3%2B-F05138?logo=swift&logoColor=white)
![iOS 9+](https://img.shields.io/badge/iOS-9%2B-000000?logo=apple&logoColor=white)
![UIKit](https://img.shields.io/badge/UIKit-Auto%20Layout-blue)
![AFNetworking](https://img.shields.io/badge/Networking-AFNetworking%202.5-lightgrey)
![Yelp API](https://img.shields.io/badge/API-Yelp%20v2-FF1A1A)

![Demo](docs/assets/demo2.gif)

> Restaurant search app that authenticates against the Yelp v2 API using OAuth 1.0a via BDBOAuth1Manager, displaying live business results in a self-sizing UITableView with per-row rating images, distance calculations, and an inline search bar.

## Features

- **OAuth 1.0a authentication:** `YelpClient` subclasses `BDBOAuth1RequestOperationManager`, storing the consumer key/secret and pre-fetched access token via `BDBOAuth1Credential` so every `AFHTTPRequestOperation` is signed automatically without manual HMAC-SHA1 work
- **Parameterized search:** `searchWithTerm(_:sort:categories:deals:completion:)` builds a query dictionary with `ll`, `sort`, `category_filter`, and `deals_filter` keys, then issues a GET to `api.yelp.com/v2/search` via `AFHTTPRequestOperationManager`
- **Sort modes:** A `YelpSortMode` enum (`bestMatched`, `distance`, `highestRated`) maps directly to Yelp API integer sort values passed as query parameters
- **Business model parsing:** `Business.init(dictionary:)` extracts nested `location.address` and `location.neighborhoods`, joins category name tuples into a comma-separated string, and converts the raw `distance` field from meters to miles (`milesPerMeter = 0.000621371`)
- **Self-sizing table rows:** `UITableViewAutomaticDimension` with `estimatedRowHeight` lets Auto Layout drive row height based on multi-line `nameLabel` and `addressLabel` content
- **Image loading via UIImageView+AFNetworking:** `BusinessCell` calls `setImageWith(_:)` on both `thumbImageView` (business photo) and `ratingImageView` (Yelp star rating image URL), with corner radius clipping applied to the thumbnail via `layer.cornerRadius` and `clipsToBounds`
- **Live search:** The `UISearchBar` embedded in `navigationItem.titleView` triggers `Business.searchWithTerm` on each `textDidChange` event, re-fetching from the Yelp API rather than filtering a local cache
- **Singleton client:** `YelpClient.sharedInstance` is initialized once with credentials via `BDBOAuth1Credential` and reused across all search calls

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 3 |
| UI | UIKit, Auto Layout, UITableViewAutomaticDimension |
| Networking | AFNetworking 2.5, BDBOAuth1Manager |
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
