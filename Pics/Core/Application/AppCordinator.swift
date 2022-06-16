//
//  AppCordinator.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 13/06/2022.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    override func start() {
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let coordinator = ListPicsCoordinator(rootViewController: navigationController)
        addChild(coordinator)
        coordinator.start()
        coordinator.finish = { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.removeChild(coordinator)
        }
    }
}
