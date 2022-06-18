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

    // MARK: Source
    var viewTitle: String { get }
    var columns: Int { get }
    var dataChanged: Dynamic<Void> { get }

    func numberOfPics() -> Int
    func pic(at: Int) -> ListPicViewDataType?

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
    let dataChanged = Dynamic(Void())
    var pics = [Pic]()
    let columns = 3

    weak var delegate: ListPicsViewModelDelegate?

    init(repository: PicsRepositoryProtocol, delegate: ListPicsViewModelDelegate) {
        self.repository = repository
        self.delegate = delegate

        Task {
            getNextPage()
        }
    }

    func pic(at index: Int) -> ListPicViewDataType? {
        guard let pic = pics[safe: index] else { return nil }
        return ListPicViewData(pic: pic, width: imageExtent)
    }

    func numberOfPics() -> Int {
        return pics.count
    }

    func show(pic: ListPicViewDataType) {
        guard let viewData = pic as? ListPicViewData else { return }
        delegate?.showPicPage(currentPic: viewData.pic, pics: pics)
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
            self.pics.append(contentsOf: pics)
            self.isLoadingNextPage = false
            self.dataChanged.value = Void()
        }
    }
}

protocol ListPicsViewModelDelegate: AnyObject {
    func showPicPage(currentPic: Pic, pics: [Pic])
}
