//
//  NYTimesAPI.swift
//  NYTimes
//
//  Created by François-Julien Alcaraz on 10/07/2018.
//  Copyright © 2018 Mokriya. All rights reserved.
//

import Foundation

typealias JSON = Any
typealias JSONArray = [JSON]
typealias JSONDictionary = [String: JSON]

private extension String {
    static let apiKey = "api-key"
    static let apiKeyValue = "54e5496eb75443aea29abca3eda6dbf6"

    static let baseUrlString = "https://api.nytimes.com/svc"
    
    static let mostViewed = "mostviewed"
    static let mostPopular = "mostpopular/v2"
    static let jsonExtension = ".json"
    
    static let contentTypeKey = "ContentType"
    static let jsonContentType = "application/json"
    
    static let resultsKey = "results"
    
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

private extension URL {
    static func mostViewed(sections: [NYTimesAPI.Parameters.Section], period: NYTimesAPI.Parameters.Period, searchQuery: String? = nil) -> URL? {
        var path = [String]()
        path.append(.baseUrlString)
        path.append(.mostPopular)
        path.append(.mostViewed)
        var sectionPath = [String]()
        sections.forEach { section in
            sectionPath.append(section.rawValue)
        }
        path.append(sectionPath.joined(separator: ","))
        path.append(period.rawValue)
        path.append(.jsonExtension)
        
        var query = [String]()
        if let searchQuery = searchQuery {
            query.append("q=\(searchQuery)")
        }
        query.append(.apiKey + "=" + .apiKeyValue)
        
        guard let composedUrl = URL(string: "?" + query.joined(separator: "&"), relativeTo: NSURL(string: path.joined(separator: "/") + "?") as URL?) else {
            return nil
        }
        
        return composedUrl
    }
}

private extension HTTPURLResponse {
    var isSuccess: Bool {
        return [200, 201, 202].contains(statusCode)
    }
}

final class NYTimesAPI: NSObject {
    
    static let shared = NYTimesAPI()

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
        configuration.isDiscretionary = false // Other wise, Uploading would be delayed till iOS Device is connected to power or wifi network
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    private var handlers: [URLSessionTask: (URLResponse?, Data?, Swift.Error?) -> Void] = [:]
    private var datas: [URLSessionTask: Data] = [:]
}

extension NYTimesAPI {
    struct Parameters {
        enum Period: String {
            case one = "1"
            case seven = "7"
            case thirty = "30"
        }
        
        enum Section: String{
            case allSections = "all-sections"
            case arts = "Arts"
            case automobiles = "Automobiles"
            case blogs = "Blogs"
            case books = "Books"
            case businessDay = "Business Day"
            case education = "Education"
            case fashionAndStyle = "Fashion & Style"
            case food = "Food"
            case health = "Health"
            case jobMarket = "Job Market"
            case memberCenter = "membercenter"
            case movies = "Movies"
            case multimedia = "Multimedia"
            case nyRegion = "N.Y.%20%2F%20Region"
            case nytNow = "NYT Now"
            case obituaries = "Obituaries"
            case open = "Open"
            case opinion = "Opinion"
            case publicEditor = "Public Editor"
            case realEstate = "Real Estate"
            case science = "Science"
            case sports = "Sports"
            case style = "Style"
            case sundayReview = "Sunday Review"
            case tMagazine = "T Magazine"
            case technology = "Technology"
            case theUpshot = "The Upshot"
            case theater = "Theater"
            case timesInsider = "Times Insider"
            case todayPaper = "Today’s Paper"
            case travel = "Travel"
            case us = "U.S."
            case world = "World"
            case yourMoney = "Your Money"
        }
    }
    
    enum Error: LocalizedError {
        case invalidURL
        case noJSON
        case invalidJSON(JSON)
        case unknown(Swift.Error?)
        
        public var errorDescription: String? {
            switch self {
            case .invalidURL:
                return NSLocalizedString("INVALID_URL_ERROR", comment: "Error when url is invalid")
            case .noJSON:
                return NSLocalizedString("MISSING_JSON_ERROR", comment: "Error when server is missing json")
            case .invalidJSON( _):
                return NSLocalizedString("JSON_FORMAT_ERROR", comment: "Error related to format of the json")
            case .unknown(let error):
                guard let error = error else { return NSLocalizedString("UNKNOWN_ERROR", comment: "Error unknown") }
                return error.localizedDescription
            }
        }
    }
}

private extension NYTimesAPI {
    func getMostViewed(sections: [Parameters.Section], period: Parameters.Period, searchQuery: String? = nil, completionHandler: @escaping (Result<[Article]>) -> Void) {
        var request: URLRequest

        do {
            guard let mostViewedURL = URL.mostViewed(sections: sections, period: period, searchQuery: searchQuery) else { throw Error.invalidURL }
            request = URLRequest(url: mostViewedURL)
        }
        catch {
            completionHandler(.failure(error))
            return
        }

//        request.setValue(.jsonContentType, forHTTPHeaderField: .contentTypeKey)
//        request.httpMethod = .get

        let task = session.dataTask(with: request)
        handlers[task] = { response, data, error in
            let result = Result<[Article]> {
                guard
                    let response = response as? HTTPURLResponse,
                    response.isSuccess
                    else { throw Error.unknown(error) }
                
                guard
                    let data = data,
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                    else { throw Error.noJSON }

                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(Results.self, from: data)
                    return results.articles
                }
                catch {
                    throw Error.invalidJSON(json)
                }
            }
            completionHandler(result)
        }
        task.resume()
    }
}

extension NYTimesAPI {
    func getMostViewed(completionHandler: @escaping (Result<[Article]>) -> Void) {
        getMostViewed(sections: [.allSections], period: .seven, completionHandler: completionHandler)
    }
}

extension NYTimesAPI: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if var currentData = datas[dataTask] {
            currentData.append(data)
            datas[dataTask] = currentData
        } else {
            datas[dataTask] = data
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
        
        guard error == nil else {
            if let handler = handlers.removeValue(forKey: task) {
                handler(task.response, nil, error)
            }
            return
        }
        
        if
            let handler = handlers.removeValue(forKey: task),
            let data = datas.removeValue(forKey: task) {
            handler(task.response, data, nil)
        }
    }
}
