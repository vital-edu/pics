//
//  ShowPicViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Kingfisher
import UIKit
import Photos
import CloudKit

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

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(
            frame: CGRect(
                x: .zero,
                y: .zero,
                width: self.view.frame.width,
                height: 35
            )
        )
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.down"), style: .plain, target: self, action: #selector(saveImage)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        ], animated: false)
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
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
        view.addSubview(toolbar)
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
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            toolbar.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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

    @objc private func saveImage() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved), nil)
    }

    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        let title: String
        let message: String?
        let action: UIAlertAction

        if error != nil {
            title = "Error"
            if isAuthorizedToSavePhoto() {
                message = "Unknown error. Try it again later."
                action = UIAlertAction(title: "OK", style: .default)
            } else {
                message = "Permission to save photo denied. Change app permissions in Settings."
                action = UIAlertAction(
                    title: "Open Settings",
                    style: .default,
                    handler: { [weak self] _ in
                        self?.openPrivacySettings()
                    }
                )
            }
        } else {
            title = "Success"
            message = "Image saved on photo library"
            action = UIAlertAction(title: "OK", style: .default)
        }

        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func isAuthorizedToSavePhoto() -> Bool {
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized
        } else {
            return PHPhotoLibrary.authorizationStatus() == .authorized
        }
    }

    @objc func openPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
