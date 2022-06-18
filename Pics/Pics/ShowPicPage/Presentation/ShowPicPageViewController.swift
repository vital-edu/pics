//
//  ShowPicPageViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 18/06/2022.
//

import UIKit

class ShowPicPageViewController: BaseViewController {
    var viewModel: ShowPicPageViewModelProtocol?

    private lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        viewController.dataSource = self

        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(pageViewController)
        self.view.addSubview(pageViewController.view)

        if let currentPage = viewModel?.currentPage() {
            pageViewController.setViewControllers([currentPage], direction: .forward, animated: false)

        }

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        self.pageViewController.didMove(toParent: self)
    }
}

extension ShowPicPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ShowPicViewController,
                let id = viewController.viewModel?.pic.value.id else {
            return nil
        }
        return viewModel?.page(before: id)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ShowPicViewController, let id = viewController.viewModel?.pic.value.id else {
            return nil
        }
        return viewModel?.page(after: id)
    }
}
