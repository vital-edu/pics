//
//  ListPicsViewModel.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation

protocol ListPicsViewModelProtocol: AnyObject {
    var repository: PicsRepositoryProtocol { get }

    // MARK: properties
    var pics: Dynamic<[Pic]> { get }

    // MARK: events
}

class ListPicsViewModel: ListPicsViewModelProtocol {
    let repository: PicsRepositoryProtocol
    let pics = Dynamic([Pic]())

    init(repository: PicsRepositoryProtocol) {
        self.repository = repository

        Task {
            let result = await repository.getPics(params: PaginationParams(page: 0))
            switch result {
                case .success(let pics):
                    process(pics)
                case .failure(let error):
                    // TODO: deal with error
                    break
            }
        }
    }

    private func process(_ pics: [Pic]) {
        DispatchQueue.main.async {
            self.pics.value = pics
        }
    }
}
