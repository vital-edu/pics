//
//  ShowPicPageViewModel.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 18/06/2022.
//

import UIKit

protocol ShowPicPageViewModelProtocol {
    var delegate: ShowPicPageViewModelDelegate? { get set }

    // MARK: - Source
    func pic(at index: Int) -> Pic?
    func currentPage() -> UIViewController?
    func currentPageIndex() -> Int?
    func page(after picId: String) -> UIViewController?
    func page(before picId: String) -> UIViewController?

    // MARK: - Events
}

class ShowPicPageViewModel: ShowPicPageViewModelProtocol {
    let repository: PicsRepositoryProtocol

    weak var delegate: ShowPicPageViewModelDelegate?
    var pics: [Pic]
    var currentPic: Pic

    init(currentPic: Pic, pics: [Pic], repository: PicsRepository) {
        self.currentPic = currentPic
        self.pics = pics
        self.repository = repository
    }

    func pic(at index: Int) -> Pic? {
        return pics[safe: index]
    }

    func currentPageIndex() -> Int? {
        return nil
    }

    func currentPage() -> UIViewController? {
        return delegate?.getShowPicViewController(with: currentPic)
    }

    func page(after picId: String) -> UIViewController? {
        guard let currentPicIndex = pics.firstIndex(where: { $0.id == picId }),
            let pic = pics[safe: currentPicIndex + 1] else {
            // TODO: load next
            return nil
        }

        return delegate?.getShowPicViewController(with: pic)
    }

    func page(before picId: String) -> UIViewController? {
        guard let currentPicIndex = pics.firstIndex(where: { $0.id == picId }),
            let pic = pics[safe: currentPicIndex - 1] else {
            // TODO: load next
            return nil
        }

        return delegate?.getShowPicViewController(with: pic)
    }
}

protocol ShowPicPageViewModelDelegate: AnyObject {
    func getShowPicViewController(with pic: Pic) -> UIViewController?
}
