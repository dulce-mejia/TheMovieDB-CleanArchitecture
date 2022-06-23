//
//  MovieView.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation
import UIKit

final class MovieView: UICollectionViewCell {
    static let reusableIdentifier = "movieReusableCell"
    static let nibName = "MovieCollectionCellView"

    enum Constants {
        static let fontSize: CGFloat = 15
        static let stackAlpha: CGFloat = 0.5
        static let cornerRadius: CGFloat = 5
        static let numberOfLines: Int = 0
        static let defaultImage = UIImage(systemName: "camera")
    }
    
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .lightGray
        imageView.image = Constants.defaultImage
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.numberOfLines
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.backgroundColor = .black.withAlphaComponent(Constants.stackAlpha)
        return stack
    }()
    
    private var imageRequest: HTTPClientTask?
    
    var viewModel: MovieViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            configureViews(viewModel: viewModel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(stackContainer)
        stackContainer.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            // stack
            stackContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        self.layer.cornerRadius = Constants.cornerRadius
        self.clipsToBounds = true
    }
    
    func configureViews(viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
        guard let path = viewModel.posterUrl else { return }
        //TODO: retrieve correct task for downloading images
        // imageRequest = posterImageView.loadImage(with: path, size: .w342)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        posterImageView.image = Constants.defaultImage
        imageRequest?.cancel()
    }
}
