//
//  DBManager.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import Foundation
import SQLite3

class DBManager
{
    static let sharedInstance = DBManager()

    private init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "newsDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
 
    
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS article(headLine TEXT,description TEXT,date TEXT,imageURL TEXT,author TEXT,url TEXT,content TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    
    func insert(article:NewsListItem)
    {
        let articles = read()
        for item in articles
        {
            if item.headLine == article.headLine
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO article (headLine, description, date,imageURL,author,url,content) VALUES (?,?,?,?,?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (article.headLine as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (article.description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (article.date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (article.imageURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (article.author as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (article.url as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (article.content as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [NewsListItem] {
        let queryStatementString = "SELECT * FROM article;"
        var queryStatement: OpaquePointer? = nil
        var psns = [NewsListItem]()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let headLine = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let imageURL = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let author = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let url = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))

                psns.append(NewsListItem.init(headLine: headLine, description: description, date: date, imageURL: imageURL, author: author, url: url, content: content))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteAllData(){
        let deleteStatementStirng = "DELETE FROM article;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
        
    func isArticleExists(newsListItem: NewsListItem)-> Bool{
        
        let articles = read()
        for item in articles
        {
            if item.headLine == newsListItem.headLine
            {
                return true
            }
        }
        return false
    }
    
}

