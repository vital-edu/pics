//
//  PicsRemoteDataSource.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Alamofire
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
        let url = try getUrl(path: PicsEndpoint.list.value, queryItems: params.queryItems)
        return try await apiClient.session.request(url).serializingDecodable([Pic].self).value
    }

    func get(id: String, params: PicsParams) async throws -> UIImage {
        let url = try getUrl(path: PicsEndpoint.show(id).value, queryItems: params.queryItems)
        // TODO: implement correclty
        return UIImage()
    }

    func getDetails(id: String) async -> Pic {
        // TODO: implement correclty
        return Pic(id: "", author: "", width: 100, height: 100, url: "", downloadUrl: "")
    }

    private func getUrl(path: String, queryItems: [URLQueryItem]) throws -> URLComponents {
        guard var url = URLComponents(string: apiClient.baseUrl) else {
            throw RemoteDataSourceError.baseUrlIsNil
        }

        url.path = path
        url.queryItems = queryItems
        return url
    }
}
