//
//  Business.swift
//  Yelp
//

import Foundation

class Business {
    var name: String = ""
    var address: String = ""
    var categories: String = ""
    var distance: String = ""
    var ratingImageURL: URL?
    var imageURL: URL?
    var reviewCount: Int = 0

    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String ?? ""
        reviewCount = dictionary["review_count"] as? Int ?? 0
        if let location = dictionary["location"] as? [String: Any],
           let displayAddress = location["display_address"] as? [String] {
            address = displayAddress.joined(separator: ", ")
        }
        if let cats = dictionary["categories"] as? [[String: String]] {
            categories = cats.compactMap { $0["title"] }.joined(separator: ", ")
        }
        if let dist = dictionary["distance"] as? Double {
            distance = String(format: "%.2f mi", dist / 1609.34)
        }
        if let urlString = dictionary["image_url"] as? String {
            imageURL = URL(string: urlString)
        }
        if let rating = dictionary["rating"] as? Double {
            let ratingName = String(Int(rating * 10))
            ratingImageURL = URL(string: "https://s3-media1.fl.yelpcdn.com/assets/2/www/img/5ef3eb3cb162/ico/stars/v1/stars_\(ratingName).png")
        }
    }

    static func mockBusinesses() -> [Business] {
        let raw: [[String: Any]] = [
            ["name": "Tartine Bakery", "review_count": 4820, "rating": 4.5, "distance": 800.0,
             "categories": [["title": "Bakeries"]], "location": ["display_address": ["595 Guerrero St", "San Francisco, CA"]]],
            ["name": "Zuni Cafe", "review_count": 3210, "rating": 4.0, "distance": 1200.0,
             "categories": [["title": "American (Traditional)"]], "location": ["display_address": ["1658 Market St", "San Francisco, CA"]]],
            ["name": "Nopa", "review_count": 5670, "rating": 4.5, "distance": 2100.0,
             "categories": [["title": "American (New)"]], "location": ["display_address": ["560 Divisadero St", "San Francisco, CA"]]],
            ["name": "Delfina", "review_count": 3890, "rating": 4.5, "distance": 950.0,
             "categories": [["title": "Italian"]], "location": ["display_address": ["3621 18th St", "San Francisco, CA"]]],
            ["name": "Tacolicious", "review_count": 2340, "rating": 4.0, "distance": 600.0,
             "categories": [["title": "Mexican"]], "location": ["display_address": ["741 Valencia St", "San Francisco, CA"]]],
        ]
        return raw.map { Business(dictionary: $0) }
    }
}
