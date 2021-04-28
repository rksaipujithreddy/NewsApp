//
//  NewsManager.swift
//  NewsApp
//
//  Created by Saipujith on 28/03/21.
//

import Foundation


/// RequestParams
struct NewsQuery: Equatable{
    var category: String
    var country: String
    var page: String
    var id: String
    var count: String
}

/// Equate to avoid duplicates
func ==(lhs: NewsQuery, rhs: NewsQuery) -> Bool{
    return lhs.category == rhs.category
        && lhs.country == rhs.country
        && lhs.page == rhs.page
        && lhs.id == rhs.id
        && lhs.count == rhs.count
}


//API Response Type Enum
enum NewsResults<T>{
    case Success(result: T)
    case Failure(error: NewsErrorType)
}

// MARK: - SError
enum NewsErrorCodes: String{
    case OK
    case ERROR
    case UNAUTHORISED
}

// MARK: - SError
enum NewsErrorType: Equatable, Error{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}


// MARK: SResultsProtocol
protocol NewsResultsProtocol{
    func fetchRecomendations(params: NewsQuery?,completionHandler: @escaping NewsResultsCompletionHandler)
}

// MARK: completionHandler
typealias NewsResultsCompletionHandler = (NewsResults<NewsStatus?>) -> Void

class NewsManager {

    ///  API Req Helper: https://newsapi.org/v2/top-headlines?category=entertainment&country=in&apiKey=a9c8d82f80cd4207af5c2e5983747be3
    ///
    /// - Parameters:
    ///   - params:{ query }
    ///   - completionHandler: SResults<[Meta]>
    func fetch(params: NewsQuery?,completionHandler: @escaping NewsResultsCompletionHandler){
        guard let param = params else {
            assertionFailure("Query Missing")
            return
        }
        let url = setURL(model: param)
        print("Requesting 🚀 \(url)")
        NewsManager.getDataRequest(url: url, token: nil, contentType: nil, auth: false) { (data, err) in
            guard let response = data else {
                completionHandler(NewsResults.Failure(error: NewsErrorType.CannotFetch("An Error Occured")))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(NewsStatus.self, from: response)
                if decoded.articles?.count ?? 1 < 1{
                    let errored = try decoder.decode(NewsCode.self, from: response)
                    do{
                        completionHandler(NewsResults.Failure(error: NewsErrorType.CannotFetch(errored.message ?? "")))
                    }
                }else{
                    completionHandler(NewsResults.Success(result: decoded))
                }
            }catch _ {
                completionHandler(NewsResults.Failure(error: NewsErrorType.CannotFetch("An Error Occured")))
            }
        }
    }
    
    /// getDataRequest - Decodable Result
    ///
    /// - Parameters:
    ///   - url: API url
    ///   - parameters: Body - Params
    ///   - token: token - Default : None
    ///   - auth: if token not required send §false§
    ///   - completionHandler: Data/Err
    class func getDataRequest(url:String,token:String?,contentType:String?, auth:Bool,completionHandler:@escaping (Data?, Error?) -> ()) -> (){
        let ephemeralConfiguration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: ephemeralConfiguration)
        guard let urlStr = URL(string: url.replacingOccurrences(of: " ", with: "")) else {
            completionHandler( nil, nil)
            return
        }
        var request = URLRequest(url: urlStr)
        request.httpMethod = "GET"
        if let content = contentType {
            request.addValue(content.isEmpty ? "application/json":content, forHTTPHeaderField: "Content-Type")
        }else{
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else{
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                completionHandler(data, error)
            }
        })
        task.resume()
    }
    
    /// Request API
    ///
    /// - Parameters:
    ///   - query: category/ apiKey
    ///   - page: optional count for on demand - pull to refresh
    ///   - completion: Meta / Error
    func request(query :NewsQuery, completion: @escaping (NewsStatus?) -> Void){
        let param = NewsQuery(category: query.category, country: query.country, page: query.page, id: query.id, count: query.count)
        self.fetch(params: param) { (result: NewsResults<NewsStatus?>) -> Void in
            switch (result) {
            case .Success(let movies):
                completion(movies )
                print("Success  ✅ \n Total \(movies?.articles?.count ?? 1) \n PageTotal \(movies?.totalResults ?? 1)")
            case .Failure(_):
                completion(nil)
                print("Failure  ❌\(NewsErrorType.CannotFetch("Error"))")
            }
        }
    }
    
    ///Constructor : URL
    func setURL(model : NewsQuery) -> String {
        let baseurl     = "https://newsapi.org/v2/top-headlines?"
        let category    = "category=\(model.category)&"
        let country     = "country=\(model.country)&"
        let key         = "apiKey=\(model.id)"
        let url         = baseurl + category + country + key
        return url
    }
}

