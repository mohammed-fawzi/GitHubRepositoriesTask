//
//  GitHubClient.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

class GitHubClient {
    private let baseEndpointUrl = URL(string: "https://api.github.com/users/JakeWharton/")!
    private let session = URLSession(configuration: .default)
    
    
    func fetchRepositories(withRequest request: GetRepositoriesRequest,
                           page: Int,
                           completion: @escaping(Result<PagedRepositoriesResponse,ResponseError>)->Void) {
        
        request.updateQueiry(forKey: "page", withValue: page)
        let url = constructURL(for: request)
    
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.network))
                    return
            }
    
            guard let parsedResponse = self.parseResponse(data: data, response: httpResponse) else{
                completion(Result.failure(ResponseError.decoding))
                return
            }
            
            completion(Result.success(parsedResponse))
        })
        
        task.resume()
    }
    
    
    func parseResponse(data: Data, response: HTTPURLResponse)-> PagedRepositoriesResponse?{
        let decoder = JSONDecoder()
        do{
            let decodedResponse = try decoder.decode([Repository].self, from: data)
            var pagedRepositories = PagedRepositoriesResponse(repositories: decodedResponse, hasMore: true)
            if let linkHeader = response.allHeaderFields["Link"] as? String  {
                if !linkHeader.contains("rel=\"next\"") {
                    pagedRepositories.hasMore = false
                }
            }
            return pagedRepositories
        }catch{
            return nil
        }
    }
    
}


extension GitHubClient {
    private func constructURL(for request: GetRepositoriesRequest) -> URL {
        guard let baseUrl = URL(string: request.resourceName, relativeTo: baseEndpointUrl) else {
            fatalError("Bad resourceName: \(request.resourceName)")
        }
        guard let completeUrl = baseUrl.withQueries(request.queires) else {
            fatalError("Bad queries: \(request.queires)")
        }
        
        return completeUrl
    }
    
}
