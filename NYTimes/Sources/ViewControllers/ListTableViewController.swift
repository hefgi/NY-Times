//
//  ListTableViewController.swift
//  NYTimes
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    private let listToDetailSegue = "listToDetailSegue"
    
    private var articles: [Article] = [Article]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var selectedIndexPath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logo for navigation bar
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "nytimes"))
        
        // dynamic height cells in tableview
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 122
        
        // fix empty rows when articles array is empty
        tableView.tableFooterView = UIView()
        
        // UI Testing accessibility identifier
        tableView.accessibilityIdentifier = "ListTableView"
        
        NYTimesAPI.shared.getMostViewed { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == listToDetailSegue,
            let detailVC = segue.destination as? DetailViewController,
            let selectedIndexPath = selectedIndexPath {
            detailVC.article = articles[selectedIndexPath.row]
        }
    }
    
    // MARK: - Private functions
    private func showAlert(error: Error?) {
        let message = error?.localizedDescription ?? NSLocalizedString("Error", comment: "Error")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Error"), style: .cancel))
        present(alert, animated: true)
    }


    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell,
            articles.count > indexPath.row
            else { return UITableViewCell() }

        cell.configure(articles[indexPath.row], at: indexPath)
        
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: listToDetailSegue, sender: self)
    }
}
