//
//  FeedViewController.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class FeedViewController: UIViewController {

    enum Constants {
        static let stackSpacing: CGFloat = 5
        static let imageViewHeight: CGFloat = 160
        static let imageViewWidth: CGFloat = 160 * 0.7
        static let sectionHeaderHeight: CGFloat = 50
    }

    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Constants.stackSpacing
        return stack
    }()

    private var movieFeedCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.backgroundColor = .clear
        return collection
    }()

    private let viewModel: FeedViewModel
    private let disposeBag = DisposeBag()
    public weak var coordinator: MainCoordinator?

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupObservers()
        viewModel.loadFeed()
    }

    private func setupUI() {
        view.addSubview(mainStackView)
//        mainStackView.addArrangedSubview(searchBySegmented)
//        mainStackView.addArrangedSubview(clearResultsButton)
        mainStackView.addArrangedSubview(movieFeedCollectionView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            mainStackView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
//        clearResultsButton.addTarget(self, action: #selector(clearList), for: .touchUpInside)
//        searchBySegmented.addTarget(self, action: #selector(selectSearchType(sender:)), for: .valueChanged)
        setupNavigationBar()
        registerCellView()
    }

    private func setupNavigationBar() {
        title = viewModel.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func registerCellView() {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.headerReferenceSize = CGSize(width: view.bounds.width,
                                                          height: Constants.sectionHeaderHeight)
        collectionFlowLayout.itemSize = CGSize(width: Constants.imageViewWidth,
                                               height: Constants.imageViewHeight)
        movieFeedCollectionView.collectionViewLayout = collectionFlowLayout

        movieFeedCollectionView.register(MovieSectionView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: MovieSectionView.identifier)
        movieFeedCollectionView.register(MovieView.self, forCellWithReuseIdentifier: MovieView.reusableIdentifier)
        movieFeedCollectionView.delegate = self
        movieFeedCollectionView.dataSource = self
    }

    private func setupObservers() {
        viewModel.sectionsAndMovies.asObservable()
            .subscribe { [weak self ] _ in
                self?.movieFeedCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

//        viewModel.isHiddenClearButton
//            .bind(to: clearResultsButton.rx.isHidden)
//            .disposed(by: disposeBag)
    }
}
extension FeedViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.getSectionsCount()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getMoviesCountBySection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieView.reusableIdentifier, for: indexPath)
        if let cell = cell as? MovieView {
            let moviesBySection = viewModel.getMoviesCountBySection(section: indexPath.section)
            guard moviesBySection != .zero else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.getMovieViewModel(by: indexPath)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: MovieSectionView.identifier,
                                                                           for: indexPath) as? MovieSectionView
        else {
            return UICollectionReusableView()
        }
        header.viewModel = MovieSectionViewModel(title: sectionHeader(with: indexPath) ?? "Results")
        return header
    }

    private func sectionHeader(with indexPath: IndexPath) -> String? {
        guard let section = viewModel.getFeedSection(by: indexPath) else {
            return nil
        }
        return section.title
    }
}
extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovieViewModel = viewModel.getMovieViewModel(by: indexPath) else {
            return
        }
        coordinator?.showDetail(selectedMovieViewModel)
    }
}
