//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Saipujith on 29/03/21.
//

import Foundation

import UIKit


class NewsListViewModel: NSObject {
    var items = [NewsListItem]()
    
    override init() {
        
        super.init()
    }
    
    func data(results: [NewsArticles?]){
        if results.count > 0 {
            for result in results {
                if let headLine = result?.title, let description = result?.description, let date = result?.publishedAt,let author = result?.author,let url = result?.url,let content = result?.content,let imageURL = result?.urlToImage {
                    let details = NewsListItem(headLine: headLine, description: description, date: date, imageURL: imageURL, author: author, url: url, content: content)
                    items.append(details)
                }
            }
        }
    }
}
//MARK: - VM
struct NewsListItem {
    
    var headLine: String
    var description: String
    var date: String
    var imageURL: String
    var author: String
    var url: String
    var content: String
    
    init(headLine: String, description: String, date: String,imageURL: String,author:String,url:String,content:String) {
        self.headLine = headLine
        self.description = description
        self.date = date
        self.imageURL = imageURL
        self.author = author
        self.url = url
        self.content = content
    }
}




