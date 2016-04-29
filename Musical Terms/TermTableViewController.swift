//
//  MainTableViewController.swift
//  Musical Terms
//
//  Created by Ryan Wang on 2016-04-26.
//  Copyright © 2016 Ryan Wang. All rights reserved.
//

import UIKit

class TermTableViewController: UITableViewController {
    
    var table = [Term]()
    var filteredTable = [Term]()
    var data: Term!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    func filterTableForSearchContent(searchText: String, scope: String = "All") {
        filteredTable = table.filter { Term in
            return Term.word.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.Plain, target:nil, action:nil)

        //Load data into table
        loadTable()
        
        //Setting up search bar
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor.grayColor()
        searchController.searchBar.placeholder = "Search for a term"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredTable.count
        }
        return table.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TermTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TermTableViewCell
        
        let a: Term!
        
        // Fetches the appropriate meal for the data source layout.
        if (searchController.active && searchController.searchBar.text != "") {
            a = filteredTable[indexPath.row]
        }
        else {
            a = table[indexPath.row]
        }
        
        cell.musicTerm.text = a.word
        return cell
    }
    
    //Function that's called when cell is pressed
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Debug statement
        print("pressed")
        
        if (searchController.active && searchController.searchBar.text != "") {
            self.data = filteredTable[indexPath.row]
        }
        else {
            self.data = table[indexPath.row]
        }
        self.performSegueWithIdentifier("openDetails", sender: nil)
    }
    
    //Function to prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "openDetails") {
            //Debug statement
            print("segue occuring")
            
            let detailsVC = segue.destinationViewController as! DetailsViewController
            detailsVC.details = self.data
        }
    }
}

extension TermTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterTableForSearchContent(searchController.searchBar.text!)
    }
}

