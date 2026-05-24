//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Gerard Recinto on 2017.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit

@MainActor
class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    private var businesses: [Business] = []
    private var filteredBusinesses: [Business] = []
    private lazy var searchBar = UISearchBar()

    private var isSearching: Bool {
        !(searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        loadBusinesses(term: "Restaurants")
    }

    private func loadBusinesses(term: String) {
        YelpClient.shared.searchBusinesses(term: term) { [weak self] results in
            self?.businesses = results
            self?.filteredBusinesses = results
            self?.tableView.reloadData()
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredBusinesses = businesses
        } else {
            filteredBusinesses = businesses.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadBusinesses(term: searchBar.text ?? "")
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? filteredBusinesses.count : businesses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        let business = isSearching ? filteredBusinesses[indexPath.row] : businesses[indexPath.row]
        cell.business = business
        return cell
    }
}
