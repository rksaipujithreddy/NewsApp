//
//  NewsStatus.swift
//  NewsApp
//
//  Created by Saipujith on 28/03/21.
//

import Foundation


struct NewsStatus : Codable {
    let status       : String?
    let totalResults : Int?
    let articles     : [NewsArticles]?

    enum CodingKeys: String, CodingKey {

        case status       = "status"
        case totalResults = "totalResults"
        case articles     = "articles"
    }

    init(from decoder: Decoder) throws {
        let values   = try decoder.container(keyedBy: CodingKeys.self)
        status       = try values.decodeIfPresent(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        articles     = try values.decodeIfPresent([NewsArticles].self, forKey: .articles)
    }

}
