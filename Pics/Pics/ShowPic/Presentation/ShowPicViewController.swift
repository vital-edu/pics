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

    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let navigationSubtitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private(set) var imageView: UIImageView = {
        let view = UIImageView()
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFit
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    private let imageDetailsView = PicDetailsView()

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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(
            frame: CGRect(
                x: .zero,
                y: .zero,
                width: self.view.frame.width,
                height: 50
            )
        )
        toolbar.setItems([
            UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(openImageInBrowser)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: self.imageDetailsView),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.down"), style: .plain, target: self, action: #selector(saveImage)),
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

            scrollView.topAnchor.constraint(equalTo: optionsSegmentedControl.safeAreaLayoutGuide.bottomAnchor, constant: ViewMetrics.spacing),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            toolbar.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        guard let viewModel = viewModel else { return }

        for segment in viewModel.effects {
            optionsSegmentedControl.insertSegment(withTitle: segment.value, at: segment.key, animated: false)
        }

        let stackView = UIStackView(arrangedSubviews: [
            navigationTitleLabel,
            navigationSubtitleLabel,
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        self.navigationItem.titleView = stackView

        viewModel.pic.bindAndFire { [weak self] pic in
            guard let self = self else { return }

            self.navigationTitleLabel.attributedText = NSMutableAttributedString().bold("Image \(pic.id)", size: 14)
            self.navigationSubtitleLabel.attributedText = NSMutableAttributedString().normal("\(pic.width) x \(pic.height)", size: 12)

            self.imageView.kf.setImage(with: pic.url)
            self.optionsSegmentedControl.selectedSegmentIndex = pic.selectedEffect

            self.imageDetailsView.setup(author: pic.author)
        }
    }

    @objc private func saveImage() {
        guard let image = imageView.image else { return }

        let okAction = UIAlertAction(title: "Save", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved), nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(
            title: "Save image",
            message: "Are you sure you want to save the image to your photo library?",
            preferredStyle: .alert
        )
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)

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

    @objc private func openImageInBrowser() {
        guard let picUrl = viewModel?.pic.value.url else { return }
        UIApplication.shared.open(picUrl, options: [:], completionHandler: nil)
    }
}
