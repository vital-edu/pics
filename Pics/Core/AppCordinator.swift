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
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    override func finish() {}
}
