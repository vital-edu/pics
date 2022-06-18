//
//  PicDetailsView.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 18/06/2022.
//

import Foundation
import UIKit

class PicDetailsView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString().bold("Author", size: 14)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
        ])

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(author: String) {
        subtitleLabel.text = author
    }
}

extension PicDetailsView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(stackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
