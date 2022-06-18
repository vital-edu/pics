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
    var viewTitle: String { get }
    var pics: Dynamic<[ListPicViewDataType]> { get }
    var columns: Int { get }

    // MARK: events
    func show(pic: ListPicViewDataType)
    func getNextPage()
}

class ListPicsViewModel: ListPicsViewModelProtocol {
    private let utils = PicUtils(baseUrl: PicsApiClient.baseUrl)
    private let imageExtent = 100
    private var isLoadingNextPage = false
    private var currentPage = 0;

    let viewTitle = "Pics"
    let repository: PicsRepositoryProtocol
    let pics = Dynamic([ListPicViewDataType]())
    let columns = 3

    weak var delegate: ListPicsViewModelDelegate?

    init(repository: PicsRepositoryProtocol, delegate: ListPicsViewModelDelegate) {
        self.repository = repository
        self.delegate = delegate

        Task {
            getNextPage()
        }
    }

    func show(pic: ListPicViewDataType) {
        guard let viewData = pic as? ListPicViewData else { return }
        delegate?.show(pic: viewData.pic)
    }

    func getNextPage() {
        if isLoadingNextPage { return }
        isLoadingNextPage = true

        Task {
            let page = currentPage + 1
            let result = await repository.getPics(params: PaginationParams(page: page, limit: 15))
            switch result {
                case .success(let pics):
                    process(pics, page: page)
                case .failure(let error):
                    // TODO: deal with error
                    break
            }
        }
    }

    private func process(_ pics: [Pic], page: Int) {
        DispatchQueue.main.async {
            self.currentPage = page
            self.pics.value.append(contentsOf: pics.map { ListPicViewData(pic: $0, width: self.imageExtent)
            })
            self.isLoadingNextPage = false
        }
    }
}

protocol ListPicsViewModelDelegate: AnyObject {
    func show(pic: Pic)
}
