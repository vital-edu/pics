//
//  ListPicsViewController.swift
//  Pics
//
//  Created by Eduardo Vital Alencar Cunha on 16/06/2022.
//

import UIKit

class ListPicsViewController: BaseViewController {
    var viewModel: ListPicsViewModelProtocol?
    private(set) var currentCell: PicViewCell?
    private let spacing = 2.0

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PicViewCell.self, forCellWithReuseIdentifier: PicViewCell.identifer)

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

extension ListPicsViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(collectionView)
    }

    func setupConstraints() {

    }

    func configureViews() {
        title = viewModel?.viewTitle
        viewModel?.dataChanged.bindAndFire { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

extension ListPicsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let nextLoadingCells = 15
        return (viewModel?.numberOfPics() ?? 0) + nextLoadingCells
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicViewCell.identifer, for: indexPath) as? PicViewCell else {
            preconditionFailure("Failed to load collection view cell")
        }

        guard let pic = viewModel?.pic(at: indexPath.item) else {
            cell.setup(imageUrl: nil)
            return cell
        }

        cell.setup(imageUrl: pic.imageUrl)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if indexPath.item < viewModel.numberOfPics() {
            return
        }

        currentCell = cell as? PicViewCell

        Task {
            viewModel.getNextPage()
        }
    }
}

extension ListPicsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns = CGFloat(viewModel?.columns ?? 1)
        let spaces = columns + 1
        let availableWidth = UIScreen.main.bounds.width - (spacing * spaces)
        let width = availableWidth / CGFloat(columns)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pic = viewModel?.pic(at: indexPath.item) else {
            return
        }
        viewModel?.show(pic: pic)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let viewController = PicPreviewViewController()
                viewController.image = (collectionView.cellForItem(at: indexPath) as? PicViewCell)?.imageView.image
                return viewController
            },
            actionProvider: nil
        )
    }
}
