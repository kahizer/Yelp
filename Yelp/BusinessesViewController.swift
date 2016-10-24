//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    
     var searchBar: UISearchBar!
    var businesses: [Business]!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        navigationController?.navigationBar.barTintColor = UIColor.red
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    func showSearchBarCancelButton(show: Bool, searchBar : UISearchBar) {
        searchBar.setShowsCancelButton(show, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searching for " + searchText)
        
        Business.searchWithTerm(term: searchText) { (businesses :[Business]?, error:Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
//        Business.searchWithTerm(term: searchText, sort: nil, categories: ni;;, deals: nil) { (businesses:[Business]?, error:Error?) in
//            self.businesses = businesses
//            self.tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let navigationController = segue.destination as? UINavigationController
//        let filtersViewController = navigationController?.viewControllers[0] as! FiltersViewController
//        filtersViewController.delegate = self;
//     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        let filtersViewController = navigationController?.viewControllers[0] as! FiltersViewController
        filtersViewController.delegate = self;
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        //Business.searchWithTerm(term: "Restaurants", completion: <#T##([Business]?, Error?) -> Void#>)
        
        let sortModes = [YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated]
        
        let categories = filters["categories"] as? [String]
        let deals = filters["deals"] as? Bool
        let distance = filters["distance"] as? String
        let sortString = filters["sort"] as? String
        let sort = sortModes[Int(sortString!)!] as! YelpSortMode
        
        Business.searchWithTerm(term: "restaurants", sort: sort, categories: categories, deals: deals) { (businesses:[Business]?, error:Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
//        Business.searchWithTerm(term: "Restaurents", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error:Error!) in
//            self.businesses = businesses
//            self.tableView.reloadData()
//        }
    }
    
    
}
