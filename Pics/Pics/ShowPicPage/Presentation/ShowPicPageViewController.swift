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
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false

        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

extension ShowPicPageViewController: ViewConfiguration {
    func buildViewHierarchy() {
        addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        guard let currentPage = viewModel?.currentPage() else { return }
        pageViewController.setViewControllers([currentPage], direction: .forward, animated: false)
        navigationItem.titleView = currentPage.navigationItem.titleView
    }
}

extension ShowPicPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        navigationItem.titleView = pendingViewControllers.first?.navigationItem.titleView
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
