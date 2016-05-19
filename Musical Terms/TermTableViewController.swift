//
//  MainTableViewController.swift
//  Musical Terms
//
//  Created by Ryan Wang on 2016-04-26.
//  Copyright © 2016 Ryan Wang. All rights reserved.
//

import UIKit

class TermTableViewController: UITableViewController {
    
    //Declaration of variables and searchController
    var table = [Term]()
    var filteredTable = [Term]()
    var data: Term!
    
    var typesSelected = [String]()
    
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
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        //Load types array
        loadTypes()

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

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Returns the size of the filtered table is a search is in progress, else returns size of full table 
        if searchController.active && searchController.searchBar.text != "" {
            return filteredTable.count
        }
        return table.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TermTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TermTableViewCell
        
        //Gets either the regular table or the filtered one if a search is in progress, and set the cell to it
        //Also takes account of the categories
        if (searchController.active && searchController.searchBar.text != "") {
            cell.musicTerm.text = filteredTable[indexPath.row].word
        }
        else if (typesSelected.contains(table[indexPath.row].type)){
            //Set the text of the cell to match the text in the table, only if the category is found in the typesSelected array
            cell.musicTerm.text = table[indexPath.row].word
        }
        
        return cell
    }
    
    //Function that's called when cell is pressed
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Debug statement
        print("pressed")
        
        //Gets either the full table or the filtered one if a search is in progress, store it in a termp variable, which will be accessed in the segue
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
            
            //Create detailsVC as the destination of the segue, and copy the data over so that it can be accessed
            let detailsVC = segue.destinationViewController as! DetailsViewController
            detailsVC.details = self.data
        }
    }
    
    func loadTypes() {
        typesSelected.append("dynamics")
        typesSelected.append("tempo")
        typesSelected.append("tempoRelated")
        typesSelected.append("style")
        typesSelected.append("italian")
        typesSelected.append("conjunction")
        typesSelected.append("french")
        typesSelected.append("german")
    }
    
    @IBAction func unwindToTermTable(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SettingsViewController {
            self.typesSelected = sourceViewController.typesSelected
            tableView.reloadData()
            //print(self.typesSelected)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TermTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterTableForSearchContent(searchController.searchBar.text!)
    }
}

