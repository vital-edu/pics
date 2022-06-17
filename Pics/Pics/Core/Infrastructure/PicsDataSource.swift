//
//  PicsDataSource.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation

protocol PicsDataSource {
    func getAll(params: PaginationParams) async throws -> [Pic]
}
