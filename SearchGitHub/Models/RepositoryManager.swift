//
//  RepositoryManager.swift
//  SearchGitHub
//
//  Created by Mahalakshmi Raveenthiran on 01/07/21.
//

import Foundation

enum RepoError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct RepositoryManager {
    let resourceURL: URL
    
    init(searchRepo: String) {
        let resourceString = "https://api.github.com/search/repositories?q=\(searchRepo)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func getRepos(completion: @escaping(Result<[Item], RepoError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let repoResponse = try decoder.decode(RepositoryData.self, from: jsonData)
                //let repoCount = repoResponse.total_count
                let repoDetails = repoResponse.items 
                completion(.success(repoDetails))
            } catch {
                print(error)
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    

    
//    func getCount(completion: (Result<RepositoryData, RepoError>) -> Void) {
//        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
//            guard let jsonData = data else {
//                completion(.failure(.noDataAvailable))
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let repoResponse = try decoder.decode(RepositoryData.self, from: jsonData)
//                let repoCount = repoResponse.total_count
//                //let repoDetails = repoResponse.items
//                completion(.success(repoCount))
//            } catch {
//                print(error)
//                completion(.failure(.canNotProcessData))
//            }
//        }
//        dataTask.resume()
//    }
}

