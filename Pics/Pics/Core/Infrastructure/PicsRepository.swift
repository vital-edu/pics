//
//  PicsRepository.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol PicsRepositoryProtocol {
    var remoteDataSource: PicsDataSource { get }

    func getPics(params: PaginationParams) async -> Result<[Pic], Error>
}

struct PicsRepository: PicsRepositoryProtocol {
    let remoteDataSource: PicsDataSource

    init(remoteDataSource: PicsDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getPics(params: PaginationParams) async -> Result<[Pic], Error> {
        do {
            let result = try await remoteDataSource.getAll(params: params)
            return .success(result)
        } catch {
            // TODO: transform error
            return .failure(error)
        }
    }
}
