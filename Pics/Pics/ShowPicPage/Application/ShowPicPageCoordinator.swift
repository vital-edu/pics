//
//  ShowPicPageCoordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 18/06/2022.
//

import UIKit

class ShowPicPageCoordinator: Coordinator {
    private let pics: [Pic]
    private let currentPic: Pic
    private weak var rootViewController: UINavigationController?

    init(rootViewController: UINavigationController?, currentPic: Pic, pics: [Pic]) {
        self.rootViewController = rootViewController
        self.currentPic = currentPic
        self.pics = pics
    }

    override func start() {
        let apiClient = PicsApiClient()
        let remoteDataSource = PicsRemoteDataSource(apiClient: apiClient)
        let repository = PicsRepository(remoteDataSource: remoteDataSource)
        let viewModel = ShowPicPageViewModel(currentPic: currentPic, pics: pics, repository: repository)
        viewModel.delegate = self
        let viewController = ShowPicPageViewController()

        viewController.viewModel = viewModel

        setDeallocallable(with: viewController)
        rootViewController?.pushViewController(viewController, animated: true)
    }
}

extension ShowPicPageCoordinator: ShowPicPageViewModelDelegate {
    func getShowPicViewController(with pic: Pic) -> UIViewController? {
        let apiClient = PicsApiClient()
        let remoteDataSource = PicsRemoteDataSource(apiClient: apiClient)
        let repository = PicsRepository(remoteDataSource: remoteDataSource)
        let viewModel = ShowPicViewModel(pic: pic, repository: repository)
        let viewController = ShowPicViewController()
        viewController.viewModel = viewModel

        return viewController
    }
}
