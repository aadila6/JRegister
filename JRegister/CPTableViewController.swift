//
//  CPTableViewController.swift
//  JRegister
//
//  Created by Adila on 8/21/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import ContactsUI
import PhoneNumberKit

protocol CountryCodeDelegate: class {
    func CPTableViewControllerDidPickCountry(_ country: CPTableViewController.Country)
}

class CPTableViewController: UITableViewController{
    
    weak var delegate: CountryCodeDelegate?
    var filteredCountries: [Country] = []
    var allCountries : [Country] = []
    var countries: [[Country]] = []
    lazy var searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: VC Initing")
        commonInit()
//        self.tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        print("DEBUG: Finished Loading Search Bar")
        loadCountry()
        print("DEBUG: Finished Loading Countries")
        
//      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        print(self.countries)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func loadCountry(){
        let phoneNumberKit = PhoneNumberKit()
        var commonCountryCodes: [String] = PhoneNumberKit.CountryCodePicker.commonCountryCodes
        self.allCountries = phoneNumberKit
            .allCountries()
            .compactMap({ Country(for: $0, with: phoneNumberKit) })
            .sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })
        self.countries = {
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
            result.append(popular)
            return result + countries
        }()
//        self.tableView.reloadData()
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
    
    func country(for indexPath: IndexPath) -> Country {
//        self.isFiltering ? filteredCountries[indexPath.row] : countries[indexPath.section][indexPath.row]
        countries[indexPath.section][indexPath.row]
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        isFiltering ? 1 : countries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        isFiltering ? filteredCountries.count : countries[section].count
//        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath)
        let country = self.country(for: indexPath)
        print("LOADING: \(indexPath)")
        cell.textLabel?.text = country.prefix + " " + country.flag
        cell.detailTextLabel?.text = country.name
        cell.textLabel?.font = .preferredFont(forTextStyle: .callout)
        cell.detailTextLabel?.font = .preferredFont(forTextStyle: .body)
        return cell
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard !isFiltering else {
            return nil
        }
        var titles: [String] = []
        
        return titles + countries.suffix(countries.count - titles.count).map { group in
            group.first?.name.first
                .map(String.init)?
                .folding(options: .diacriticInsensitive, locale: nil) ?? ""
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.country(for: indexPath)
        print(country)
        delegate?.CPTableViewControllerDidPickCountry(country)
        print("Passed to the delegate")
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CPTableViewController: UISearchResultsUpdating {
    
    struct Country {
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
class Cell: UITableViewCell {
       
       static let reuseIdentifier = "Cell"
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: .value2, reuseIdentifier: Self.reuseIdentifier)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
   }
