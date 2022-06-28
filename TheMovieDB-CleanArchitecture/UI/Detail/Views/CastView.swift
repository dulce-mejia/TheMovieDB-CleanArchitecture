//
//  CastView.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 28/06/22.
//

import Foundation
import UIKit

public final class CastView: UICollectionViewCell {
    static var reusableIdentifier = "castCell"
    static var nibName = "CastCollectionCellView"
    private static let defaultImage: UIImage? = UIImage(systemName: "camera")

    enum Constants {
        static let spacing: CGFloat = 8
        static let numberOfLines: Int = 2
        static let fontSize: CGFloat = 10
        static let castLabelHeight: CGFloat = 10
        static let aspectRatio: CGFloat = 1.0/1.0
    }

    private var stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constants.spacing
        return stack
    }()

    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .lightGray
        imageView.image = CastView.defaultImage
        return imageView
    }()
    private var nameLabelView: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(stackContainer)
        stackContainer.addArrangedSubview(photoImageView)
        stackContainer.addArrangedSubview(nameLabelView)

        NSLayoutConstraint.activate([
            stackContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // Image view
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor,
                                                  multiplier: Constants.aspectRatio),
            nameLabelView.heightAnchor.constraint(equalToConstant: Constants.castLabelHeight)
        ])

        photoImageView.layer.cornerRadius = 5.0
        photoImageView.clipsToBounds = true
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
    }

    public var viewModel: CastViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            configure(viewModel: viewModel)
        }
    }

    func configure(viewModel: CastViewModel) {
        nameLabelView.text = viewModel.cast.name
        guard let path = viewModel.cast.profilePath else { return }
    }
}
