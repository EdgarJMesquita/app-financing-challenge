//
//  RequestService.swift
//  App de Finanças
//
//  Created by Edgar on 23/06/25.
//

import UIKit

class RequestService {
    
    
//    func request<T>(
//        with path: String,
//        model: T.Type,
//        queryItems: [URLQueryItem]=[],
//        cache: Bool = true
//    ) async throws -> T where T : Decodable {
//        
//        
//        guard let apiKey = EnvManager.get(key: .tmdbAPIKey) else {
//            throw MWLError.missingConfigFile
//        }
//
//        let urlString = "\(baseURL)\(path)"
//        
//        guard var components = URLComponents(string: urlString) else {
//            throw MWLError.invalidURL
//        }
//
//        components.queryItems = queryItems
//        
//        components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
//        
//        if let sessionId = PersistenceManager.getSessionId() {
//            components.queryItems?.append(URLQueryItem(name: "session_id", value: sessionId))
//        }
//        
//        if let user = PersistenceManager.getUser() {
//            let language = "\(user.iso639_1)-\(user.iso3166_1)"
//            components.queryItems?.append(URLQueryItem(name: "language", value: language))
//        }
//        
//        guard let url = components.url else {
//            throw MWLError.invalidURL
//        }
//        
//        
//        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 300.0)
//        request.httpMethod = "GET"
//
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let sessionConfig = URLSessionConfiguration.default
//        
//        sessionConfig.urlCache = cache ? URLCache.shared : nil
//       
//        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
//        
//        let session = URLSession(configuration: sessionConfig)
//        
//        do {
//            let (data, response) = try await session.data(for: request)
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                throw MWLError.invalidResponse
//            }
//
//            return try JSONDecoder().decode(model, from: data)
//
//        } catch {
//            print(error)
//            throw MWLError.invalidResponse
//        }
//
//    }
    
}
