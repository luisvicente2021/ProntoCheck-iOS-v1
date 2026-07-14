//
//  Endpoint.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//


import Foundation

protocol Endpoint {
    var basePath: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

extension Endpoint {
    var body: Data? { nil }
    var headers: [String: String]? { nil }
}
