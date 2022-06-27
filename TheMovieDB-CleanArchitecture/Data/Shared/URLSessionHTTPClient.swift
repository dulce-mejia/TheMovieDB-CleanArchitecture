//
//  URLSessionHTTPClient.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let request = URLRequest(url: url)
        let task = task(request: request, completion: completion)
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }

    public func post(from url: URL, data: Data, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let task = task(request: request, completion: completion)
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }

    public func put(from url: URL, data: Data, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let task = task(request: request, completion: completion)
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }

    public func patch(from url: URL, data: Data, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let task = task(request: request, completion: completion)
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }

    public func delete(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = task(request: request, completion: completion)
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }

    private func task(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> URLSessionDataTask {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
    }
}
