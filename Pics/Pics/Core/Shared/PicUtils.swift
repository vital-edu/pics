//
//  PicUtils.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

struct PicUtils {
    let baseUrl: String

    init(baseUrl: String? = nil) {
        self.baseUrl = baseUrl ?? PicsApiClient.baseUrl
    }

    func getPicUrl(imageId: String, width: Int, height: Int) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }

        urlComponents.path = "/id/\(imageId)/\(width)/\(height)"
        return urlComponents.url
    }
}
