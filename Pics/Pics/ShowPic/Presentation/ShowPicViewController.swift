//
//  ShowPicViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import Kingfisher
import UIKit

class ShowPicViewController: BaseViewController {
    var viewModel: ShowPicViewModelProtocol?

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let optionsSegmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.insertSegment(withTitle: "Opaque", at: 0, animated: false)
        view.insertSegment(withTitle: "Blur", at: 1, animated: false)
        return view
    }()

    let authorLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

extension ShowPicViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(imageView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func configureViews() {
        view.backgroundColor = .white
        title = viewModel?.pic.title
        imageView.kf.setImage(with: viewModel?.pic.imageUrl)
    }
}
