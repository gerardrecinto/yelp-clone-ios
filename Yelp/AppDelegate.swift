//
//  AppDelegate.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let prefs = UserDefaults.standard

    var searchWord : String = "" { // default to Best Match
        didSet {
            prefs.setValue(searchWord, forKey: "searchWord")
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let term = prefs.string(forKey: "searchWord") {
            searchWord = term
        }
        return true
    }






}

