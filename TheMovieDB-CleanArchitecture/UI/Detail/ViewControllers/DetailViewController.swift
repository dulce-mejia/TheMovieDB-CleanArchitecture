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
        static let stackSpacing: CGFloat = 4
        static let stackMargin: CGFloat = 10
        static let castViewHeight: CGFloat = 70
        static let castViewWidth: CGFloat = 70 * 1.5
        static let castCollectionHeight: CGFloat = 80
        static let imageViewHeight: CGFloat = 160
        static let imageViewWidth: CGFloat = 160 * 0.7
        static let movieCellHeight: CGFloat = 175.0
        static let reviewHeight: CGFloat = 60.0
        static let cornerRadius: CGFloat = reviewHeight / 2
        static let segmentedHeight: CGFloat = 44
        static let titleViewHeight: CGFloat = 80
        static let reviewButtonTopMargin: CGFloat = -30
        static let reviewButtonTrailingMargin: CGFloat = -25
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
        label.numberOfLines = .zero
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
        segmented.selectedSegmentIndex = .zero
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
        setupUI()
        setupObservers()
        registerCells()
        viewModel.loadMovieDetail()
    }

    private func setupUI() {
        self.view.backgroundColor = .clear
        view.addSubview(stackContainer)
        stackContainer.addArrangedSubview(view1)
        stackContainer.addArrangedSubview(view2)
        // Setting view1
        view1.addSubview(posterImageView)
        view1.addSubview(titleLabel)
        view1.addSubview(reviewsButton)
        // Setting view2
        view2.addSubview(detailsScrollView)
        detailsScrollView.addSubview(scrollChildFirstStackContainer)
        scrollChildFirstStackContainer.addArrangedSubview(stackContainerScrollView)
        // Setting scroll content
        stackContainerScrollView.addArrangedSubview(overviewTitleLabel)
        stackContainerScrollView.addArrangedSubview(overviewLabel)
        stackContainerScrollView.addArrangedSubview(castTitleLabel)
        stackContainerScrollView.addArrangedSubview(castCollectionView)
        stackContainerScrollView.addArrangedSubview(moviesSegmented)
        stackContainerScrollView.addArrangedSubview(recommendedSimilarCollectionView)
        // Set Constraints
        NSLayoutConstraint.activate([
            stackContainer.topAnchor.constraint(equalTo: view.topAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Poster
            posterImageView.topAnchor.constraint(equalTo: view1.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: view1.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view1.trailingAnchor),
            // Title
            titleLabel.bottomAnchor.constraint(equalTo: view1.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view1.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view1.trailingAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.titleViewHeight),
            // Review button
            reviewsButton.heightAnchor.constraint(equalToConstant: Constants.reviewHeight),
            reviewsButton.widthAnchor.constraint(equalToConstant: Constants.reviewHeight),
            reviewsButton.topAnchor.constraint(equalTo: titleLabel.topAnchor,
                                               constant: Constants.reviewButtonTopMargin),
            reviewsButton.trailingAnchor.constraint(equalTo: view1.trailingAnchor,
                                                    constant: Constants.reviewButtonTrailingMargin)
        ])
        constrainstForScrollview()
        updateStackAxis(traitCollection: traitCollection)

        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
    }

    private func registerCells() {
        castCollectionView.register(CastView.self, forCellWithReuseIdentifier: CastView.reusableIdentifier)
        recommendedSimilarCollectionView.register(MovieView.self, forCellWithReuseIdentifier: MovieView.reusableIdentifier)
    }

    private func constrainstForScrollview() {
        NSLayoutConstraint.activate([
            // DetailScrollView
            detailsScrollView.topAnchor.constraint(equalTo: view2.topAnchor),
            detailsScrollView.bottomAnchor.constraint(equalTo: view2.bottomAnchor),
            detailsScrollView.trailingAnchor.constraint(equalTo: view2.trailingAnchor),
            detailsScrollView.leadingAnchor.constraint(equalTo: view2.leadingAnchor),
            // firstStackContainer scrollview
            scrollChildFirstStackContainer.topAnchor.constraint(equalTo: detailsScrollView.contentLayoutGuide.topAnchor),
            scrollChildFirstStackContainer.bottomAnchor.constraint(equalTo: detailsScrollView.contentLayoutGuide.bottomAnchor),
            scrollChildFirstStackContainer.leadingAnchor.constraint(equalTo: detailsScrollView.contentLayoutGuide.leadingAnchor),
            scrollChildFirstStackContainer.trailingAnchor.constraint(equalTo: detailsScrollView.contentLayoutGuide.trailingAnchor),
            scrollChildFirstStackContainer.widthAnchor.constraint(equalTo: view2.widthAnchor),
            // stack container scrollView
            stackContainerScrollView.trailingAnchor.constraint(equalTo: scrollChildFirstStackContainer.trailingAnchor,
                                                               constant: -Constants.stackMargin),
            stackContainerScrollView.leadingAnchor.constraint(equalTo: scrollChildFirstStackContainer.leadingAnchor,
                                                              constant: Constants.stackMargin),
            // cast collection
            castCollectionView.heightAnchor.constraint(equalToConstant: Constants.castCollectionHeight),
            // recommended collection
            recommendedSimilarCollectionView.heightAnchor.constraint(equalToConstant: Constants.movieCellHeight),
            // segmented
            moviesSegmented.heightAnchor.constraint(equalToConstant: Constants.segmentedHeight)
            ])
    }

    private func updateStackAxis(traitCollection: UITraitCollection?) {
        switch (traitCollection?.horizontalSizeClass, traitCollection?.verticalSizeClass) {
        case (.compact, .compact), (.regular, .compact):
            stackContainer.axis = .horizontal
        default:
            stackContainer.axis = .vertical
        }
    }

    private func setupObservers() {
        viewModel.recommendedSimilarObserver
            .bind(to: recommendedSimilarCollectionView.rx.items(cellIdentifier: MovieView.reusableIdentifier,
                                                                cellType: MovieView.self)) { _, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)

        viewModel.castObserver
            .bind(to: castCollectionView.rx.items(cellIdentifier: CastView.reusableIdentifier,
                                                  cellType: CastView.self)) { _, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        viewModel.poster.asObservable()
            .subscribe(onNext: { [weak self] imageData in
                guard let data = imageData else { return }
                DispatchQueue.main.async {
                    self?.posterImageView.image = UIImage(data: data)
                }
            })
            .disposed(by: disposeBag)

        moviesSegmented.addTarget(self, action: #selector(similarRecommendedAction(_:)), for: .valueChanged)
        reviewsButton.addTarget(self, action: #selector(showReviews), for: .touchUpInside)
    }

    @objc private func showReviews() {

    }

    @objc func similarRecommendedAction(_ sender: UISegmentedControl) {
        guard let type = DetailViewModel.SuggestionType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        viewModel.toggleSimilarRecommended(by: type)
    }
}
