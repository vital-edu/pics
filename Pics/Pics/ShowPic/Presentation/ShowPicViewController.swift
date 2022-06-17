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
        let view = ScaledHeightImageView()
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageInfoStackView: UIStackView = {
        let idLabel = UILabel()
        idLabel.text = "0"

        let authorLabel = UILabel()
        authorLabel.text = "Alejandro Escamilla"

        let widthLabel = UILabel()
        widthLabel.text = "5616"

        let heightLabel = UILabel()
        heightLabel.text = "2122"

        let urlLabel = UILabel()
        urlLabel.text = "https://unsplash.com/..."

        let view = UIStackView(arrangedSubviews: [
            imageView,
            idLabel,
            authorLabel,
            widthLabel,
            heightLabel,
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

    private let authorLabel: UILabel = {
        let view = UILabel()
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

            imageInfoStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageInfoStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageInfoStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
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
            self?.title = pic.title
            self?.imageView.kf.setImage(with: pic.imageUrl)
            self?.optionsSegmentedControl.selectedSegmentIndex = pic.selectedEffect
        }
    }
}
