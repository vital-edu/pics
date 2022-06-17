//
//  ListPicsCoordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Foundation
import UIKit

class ListPicsCoordinator: Coordinator {
    weak var rootViewController: UINavigationController?

    init(rootViewController: UINavigationController?) {
        self.rootViewController = rootViewController
    }

    override func start() {
        let apiClient = PicsApiClient()
        let remoteDataSource = PicsRemoteDataSource(apiClient: apiClient)
        let repository = PicsRepository(remoteDataSource: remoteDataSource)
        let viewModel = ListPicsViewModel(repository: repository, delegate: self)
        let viewController = ListPicsViewController()
        viewController.viewModel = viewModel

        setDeallocallable(with: viewController)
        rootViewController?.setViewControllers([viewController], animated: false)
    }
}

extension ListPicsCoordinator: ListPicsViewModelDelegate {
    func show(pic: Pic) {
        let coordinator = ShowPicCoordinator(rootViewController: rootViewController, pic: pic)
        addChild(coordinator)

        coordinator.start()
        coordinator.finish = { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.removeChild(coordinator)
        }
    }
}
