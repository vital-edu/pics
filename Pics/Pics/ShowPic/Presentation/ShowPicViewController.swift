//
//  ShowPicViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Kingfisher
import UIKit

class ShowPicViewController: BaseViewController {
    private struct ViewMetrics {
        static let topMargin = 8.0
        static let leftMargin = 4.0
        static let rightMargin = 4.0

        static let spacing = 8.0
    }

    var viewModel: ShowPicViewModelProtocol?

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var optionsSegmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.addTarget(self, action: #selector(changeImageEffect), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.apportionsSegmentWidthsByContent = true
        return view
    }()

    private let authorLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    @objc private func changeImageEffect(sender: UISegmentedControl) {
        viewModel?.changeEffect(to: sender.selectedSegmentIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

extension ShowPicViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(imageView)
        view.addSubview(optionsSegmentedControl)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            optionsSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewMetrics.topMargin),
            optionsSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ViewMetrics.leftMargin),
            optionsSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ViewMetrics.rightMargin),

            imageView.topAnchor.constraint(equalTo: optionsSegmentedControl.safeAreaLayoutGuide.bottomAnchor, constant: ViewMetrics.spacing),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func configureViews() {
        view.backgroundColor = .white

        guard let viewModel = viewModel else { return }

        for segment in viewModel.effects {
            optionsSegmentedControl.insertSegment(withTitle: segment.value, at: segment.key, animated: false)
        }

        viewModel.pic.bindAndFire { [weak self] pic in
            self?.title = pic.title
            self?.imageView.kf.setImage(with: pic.imageUrl)
            self?.optionsSegmentedControl.selectedSegmentIndex = pic.selectedEffect
        }
    }
}
