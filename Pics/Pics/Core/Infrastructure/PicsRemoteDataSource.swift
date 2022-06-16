//
//  PicsRemoteDataSource.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation
import UIKit

enum RemoteDataSourceError: Error {
    case apiClientIsNill
    case baseUrlIsNil
}

class PicsRemoteDataSource: PicsDataSource {
    let apiClient: ApiClientProtocol

    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }

    func getAll(params: PaginationParams) async throws -> [Pic] {
        let url = try getUrl(with: params.queryItems)
        return try await apiClient.session.request(url, method: .get).serializingDecodable([Pic].self).value
    }

    func get(id: String, params: PicsParams) async throws -> UIImage {
        let url = try getUrl(with: params.queryItems)
        // TODO: implement correclty
        return UIImage()
    }

    func getDetails(id: String) async -> Pic {
        // TODO: implement correclty
        return Pic(id: "", author: "", width: 100, height: 100, url: "", downloadIUrl: "")
    }

    private func getUrl(with queryItems: [URLQueryItem]) throws -> URLComponents {
        guard var url = URLComponents(string: apiClient.baseUrl) else {
            throw RemoteDataSourceError.baseUrlIsNil
        }

        url.queryItems?.append(contentsOf: queryItems)
        return url
    }
}
