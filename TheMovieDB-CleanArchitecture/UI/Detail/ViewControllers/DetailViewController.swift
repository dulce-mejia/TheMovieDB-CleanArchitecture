//
//  DetailViewController.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwiftUI

final class DetailViewController: UIViewController {

    enum Icons {
        case noImage, reviews

        var image: UIImage? {
            switch self {
            case .noImage:
                return UIImage(systemName: "camera")
            case .reviews:
                return UIImage(systemName: "star.bubble.fill")
            }
        }
    }

    enum Constants {
        static let fontSize_title: CGFloat = 18
        static let fontSize_body: CGFloat = 18
        static let alpha: CGFloat = 0.5
        static let cornerRadius: CGFloat = 5
        static let stackSpacing: CGFloat = 4
        static let castViewHeight: CGFloat = 70
        static let castViewWidth: CGFloat = 70 * 1.5
        static let imageViewHeight: CGFloat = 160
        static let imageViewWidth: CGFloat = 160 * 0.7
    }

    // Views
    private var stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    private var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private var view2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        imageView.image = Icons.noImage.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_title, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(Constants.alpha)
        return label
    }()
    private var reviewsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.cornerRadius
        button.clipsToBounds = true
        button.tintColor = .yellow
        button.setImage(Icons.reviews.image, for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    private var detailsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private var scrollChildFirstStackContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    private var stackContainerScrollView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Constants.stackSpacing
        return stack
    }()
    private var overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_body, weight: .semibold)
        return label
    }()
    private var overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_body)
        return label
    }()
    private var relatedMoviesSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl()
        return segmented
    }()
    private var castTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.font = UIFont.systemFont(ofSize: Constants.fontSize_body, weight: .semibold)
        return label
    }()
    private var castCollectionView: UICollectionView = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionFlowLayout)
        collectionFlowLayout.itemSize = CGSize(width: Constants.castViewWidth,
                                               height: Constants.castViewHeight)
        collection.backgroundColor = .clear
        return collection
    }()
    private var recommendedSimilarCollectionView: UICollectionView = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionFlowLayout)
        collectionFlowLayout.itemSize = CGSize(width: Constants.imageViewWidth,
                                               height: Constants.imageViewHeight)
        collection.backgroundColor = .clear
        return collection
    }()
    private var moviesSegmented: UISegmentedControl = {
        let items = ["Similar", "Recommended"]
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0
        segmented.selectedSegmentTintColor = .systemBlue
        return segmented
    }()

    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadMovieDetail()
    }

    private func setupObservers() {
        viewModel.recommendedSimilarObserver
            .bind(to: recommendedSimilarCollectionView.rx.items(cellIdentifier: MovieView.reusableIdentifier,
                                                                cellType: MovieView.self)) { [weak self] _, _, cell in
                cell.viewModel = self?.viewModel.movieViewModel
            }
            .disposed(by: disposeBag)

//        viewModel.castObserver
//            .bind(to: castCollectionView.rx.items(cellIdentifier: CastView.reusableIdentifier,
//                                                  cellType: CastView.self)) { [weak self] _, _, cell in
//                
//            }
//            .disposed(by: disposeBag)
    }
}
