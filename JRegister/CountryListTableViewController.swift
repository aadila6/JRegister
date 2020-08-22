//
//  CountryListTableViewController.swift
//  JRegister
//
//  Created by Adila on 8/14/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import PhoneNumberKit

class CountryListTableViewController: UITableViewController {
    public struct Country {
        var code: String
        var flag: String
        var name: String
        var prefix: String

        init?(for countryCode: String, with phoneNumberKit: PhoneNumberKit) {
            let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
            guard
                let name = (Locale.current as NSLocale).localizedString(forCountryCode: countryCode),
                let prefix = phoneNumberKit.countryCode(for: countryCode)?.description
            else {
                return nil
            }

            self.code = countryCode
            self.name = name
            self.prefix = "+" + prefix
            self.flag = ""
            countryCode.uppercased().unicodeScalars.forEach {
                if let scaler = UnicodeScalar(flagBase + $0.value) {
                    flag.append(String(describing: scaler))
                }
            }
            if flag.count != 1 { // Failed to initialize a flag ... use an empty string
                return nil
            }
        }
    }
    
    class Cell: UITableViewCell {

        static let reuseIdentifier = "Cell"

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value2, reuseIdentifier: Self.reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public let phoneNumberKit: PhoneNumberKit
    lazy var searchController = UISearchController(searchResultsController: nil)
    let commonCountryCodes: [String]
    var hasCurrent = true
    var hasCommon = true

    var filteredCountries: [Country] = []
    
    lazy var allCountries = phoneNumberKit.allCountries()
    .compactMap({ Country(for: $0, with: self.phoneNumberKit) })
    .sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })
    
    lazy var countries: [[Country]] = {
        let countries = allCountries
            .reduce([[Country]]()) { collection, country in
                var collection = collection
                guard var lastGroup = collection.last else { return [[country]] }
                let lhs = lastGroup.first?.name.folding(options: .diacriticInsensitive, locale: nil)
                let rhs = country.name.folding(options: .diacriticInsensitive, locale: nil)
                if lhs?.first == rhs.first {
                    lastGroup.append(country)
                    collection[collection.count - 1] = lastGroup
                } else {
                    collection.append([country])
                }
                return collection
            }

        let popular = commonCountryCodes.compactMap({ Country(for: $0, with: phoneNumberKit) })

        var result: [[Country]] = []
        // Note we should maybe use the user's current carrier's country code?
        if hasCurrent, let current = Country(for: PhoneNumberKit.defaultRegionCode(), with: phoneNumberKit) {
            result.append([current])
        }
        hasCommon = hasCommon && !popular.isEmpty
        if hasCommon {
            result.append(popular)
        }
        return result + countries
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("*******3**********")
        return 5
    }
    
    func country(for indexPath: IndexPath) -> Country {
        isFiltering ? filteredCountries[indexPath.row] : countries[indexPath.section][indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath)
        let country = self.country(for: indexPath)

        cell.textLabel?.text = country.prefix + " " + country.flag
        cell.detailTextLabel?.text = country.name

        cell.textLabel?.font = .preferredFont(forTextStyle: .callout)
        cell.detailTextLabel?.font = .preferredFont(forTextStyle: .body)

        return cell

    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0, hasCurrent {
            return NSLocalizedString("PhoneNumberKit.CountryCodePicker.Current", value: "Current", comment: "Name of \"Current\" section")
        } else if section == 0, !hasCurrent, hasCommon {
            return NSLocalizedString("PhoneNumberKit.CountryCodePicker.Common", value: "Common", comment: "Name of \"Common\" section")
        } else if section == 1, hasCurrent, hasCommon {
            return NSLocalizedString("PhoneNumberKit.CountryCodePicker.Common", value: "Common", comment: "Name of \"Common\" section")
        }
        return countries[section].first?.name.first.map(String.init)
    }
     public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //            guard !isFiltering else {
    //                return nil
    //            }
                var titles: [String] = []
                if hasCurrent {
                    titles.append("•") // NOTE: SFSymbols are not supported otherwise we would use 􀋑
                }
                if hasCommon {
                    titles.append("★") // This is a classic unicode star
                }
                return titles + countries.suffix(countries.count - titles.count).map { group in
                    group.first?.name.first
                        .map(String.init)?
                        .folding(options: .diacriticInsensitive, locale: nil) ?? ""
                }
            }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.country(for: indexPath)
        print("country: \(country.name)")
//        delegate?.countryCodePickerViewControllerDidPickCountry(country)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public init(
        phoneNumberKit: PhoneNumberKit,
        commonCountryCodes: [String] = PhoneNumberKit.CountryCodePicker.commonCountryCodes){
            self.phoneNumberKit = phoneNumberKit
            self.commonCountryCodes = commonCountryCodes
            super.init(style: .grouped)
            self.commonInit()
        }

    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
              self.phoneNumberKit = PhoneNumberKit()
              self.commonCountryCodes = PhoneNumberKit.CountryCodePicker.commonCountryCodes
              super.init(coder: coder)
              self.commonInit()
    }
    
    func commonInit() {
        self.title = NSLocalizedString("PhoneNumberKit.CountryCodePicker.Title", value: "Choose your country", comment: "Title of CountryCodePicker ViewController")

        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = .clear
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.tableView.dataSource = CountryCodePickerViewController(phoneNumberKit: phoneKitInstance).tableView.dataSource
        
//        self.tableView.dataSource = self
//        self.tableView = self.CountryVC
        print("*****2*****")
    }

    // MARK: - Table view data source

   

}
extension CountryListTableViewController: UISearchResultsUpdating {

    var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }

    var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }

    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredCountries = allCountries.filter { country in
            country.name.lowercased().contains(searchText.lowercased()) ||
                country.code.lowercased().contains(searchText.lowercased()) ||
                country.prefix.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
