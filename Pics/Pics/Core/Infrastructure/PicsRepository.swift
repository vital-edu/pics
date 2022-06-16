//
//  PicsRepository.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol PicsRepositoryProtocol {
    var localDataSource: PicsDataSource { get }

    func getPics(params: PaginationParams) async throws -> Result<[Pic], Error>
}

struct PicsRepository: PicsRepositoryProtocol {
    let localDataSource: PicsDataSource

    init(localDataSource: PicsDataSource) {
        self.localDataSource = localDataSource
    }

    func getPics(params: PaginationParams) async -> Result<[Pic], Error> {
        do {
            let result = try await localDataSource.getAll(params: params)
            return .success(result)
        } catch {
            // TODO: transform error
            return .failure(error)
        }
    }
}
