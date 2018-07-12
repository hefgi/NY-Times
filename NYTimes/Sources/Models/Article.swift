//
//  Article.swift
//  NYTimes
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import Foundation

struct Results: Codable {
    var articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case articles = "results"
    }
}

struct Article: Codable {
    var title: String
    var description: String
    var authors: String
    var publishedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description = "abstract"
        case authors = "byline"
        case publishedAt = "published_date"
    }
}
