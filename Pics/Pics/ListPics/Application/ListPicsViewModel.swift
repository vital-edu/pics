//
//  ListPicsViewModel.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation
import UIKit

protocol ListPicsViewModelProtocol: AnyObject {
    var repository: PicsRepositoryProtocol { get }

    // MARK: properties
    var pics: Dynamic<[ListPicViewDataType]> { get }

    // MARK: events
    func showPic(id: String, from viewController: UIViewController)
}

class ListPicsViewModel: ListPicsViewModelProtocol {
    private let utils = PicUtils(baseUrl: PicsApiClient.baseUrl)

    let repository: PicsRepositoryProtocol
    let pics = Dynamic([ListPicViewDataType]())

    weak var delegate: ListPicsViewModelDelegate?

    init(repository: PicsRepositoryProtocol, delegate: ListPicsViewModelDelegate) {
        self.repository = repository
        self.delegate = delegate

        Task {
            let result = await repository.getPics(params: PaginationParams(page: 0, limit: 15))
            switch result {
                case .success(let pics):
                    process(pics)
                case .failure(let error):
                    // TODO: deal with error
                    break
            }
        }
    }

    func showPic(id: String, from viewController: UIViewController) {
        delegate?.showPic(id: id, from: viewController)
    }

    private func process(_ pics: [Pic]) {
        DispatchQueue.main.async {
            self.pics.value = pics.map { ListPicViewData(pic: $0, width: 100) }
        }
    }
}

protocol ListPicsViewModelDelegate: AnyObject {
    func showPic(id: String, from viewController: UIViewController)
}
