//
//  DetailViewController.swift
//  NYTimes
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var article: Article!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = article.title
        authorsLabel.text = article.authors
        dateLabel.text = article.publishedAt
        descriptionTextView.text = article.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
