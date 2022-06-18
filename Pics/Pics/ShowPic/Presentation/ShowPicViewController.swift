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
        static let minimumImageHeight = 100.0
    }

    var viewModel: ShowPicViewModelProtocol?

    private(set) var imageView: UIImageView = {
        let view = ScaledHeightImageView()
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let idLabel = UILabel()
    private let authorLabel = UILabel()
    private let sizeLabel = UILabel()
    private let urlLabel = UILabel()

    private lazy var imageInfoStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            idLabel,
            authorLabel,
            sizeLabel,
            urlLabel,
        ])
        view.axis = .vertical
        view.distribution = .fill
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

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.addSubview(imageView)
        view.addSubview(imageInfoStackView)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(scrollView)
        view.addSubview(optionsSegmentedControl)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            optionsSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewMetrics.topMargin),
            optionsSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ViewMetrics.leftMargin),
            optionsSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ViewMetrics.rightMargin),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: ViewMetrics.minimumImageHeight),

            imageInfoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ViewMetrics.spacing),
            imageInfoStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: ViewMetrics.leftMargin),
            imageInfoStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: ViewMetrics.rightMargin),
            imageInfoStackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: optionsSegmentedControl.safeAreaLayoutGuide.bottomAnchor, constant: ViewMetrics.spacing),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func configureViews() {
        view.backgroundColor = .white

        guard let viewModel = viewModel else { return }

        for segment in viewModel.effects {
            optionsSegmentedControl.insertSegment(withTitle: segment.value, at: segment.key, animated: false)
        }

        viewModel.pic.bindAndFire { [weak self] pic in
            guard let self = self else { return }

            self.title = pic.title
            self.idLabel.attributedText = pic.id
            self.authorLabel.attributedText = pic.author
            self.urlLabel.attributedText = pic.downloadUrl
            self.sizeLabel.attributedText = pic.size
            self.imageView.kf.setImage(with: pic.url)
            self.optionsSegmentedControl.selectedSegmentIndex = pic.selectedEffect
        }
    }
}
