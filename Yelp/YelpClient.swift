//
//  YelpClient.swift
//  Yelp
//
//  Note: Yelp OAuth 1.0a API deprecated. App now uses mock data for demo.
//

import Foundation

@MainActor
final class YelpClient {

    static let shared = YelpClient()
    private init() {}

    func searchBusinesses(
        term: String,
        location: String = "San Francisco, CA",
        sort: Int = 0,
        categories: [String] = [],
        deals: Bool = false,
        completion: @escaping ([Business]) -> Void
    ) {
        let results = Business.mockBusinesses().filter { business in
            term.isEmpty || business.name.localizedCaseInsensitiveContains(term)
        }
        completion(results)
    }
}
