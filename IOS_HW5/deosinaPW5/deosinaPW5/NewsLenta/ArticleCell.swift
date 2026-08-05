//
//  ArticleCell.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import SkeletonView
import UIKit

protocol ArticleCellDelegate: AnyObject {
    func shareButtonTapped(for article: ArticleModel)
}

class ArticleCell: UITableViewCell {
    // MARK: - Variables
    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    weak var delegate: ArticleCellDelegate?
    private var article: ArticleModel?
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func setupViews() {
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 8
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            newsImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            newsImageView.widthAnchor.constraint(equalToConstant: 100),
            newsImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with article: ArticleModel) {
        self.article = article
        titleLabel.text = article.name
        
        var descriptionText = ""
        if !article.films.isEmpty {
            descriptionText += "Films: \(article.films.joined(separator: ", "))\n"
        }
        if !article.tvShows.isEmpty {
            descriptionText += "TV Shows: \(article.tvShows.joined(separator: ", "))"
        }
        
        descriptionLabel.text = descriptionText.isEmpty ? "No media info" : descriptionText
        
        if let imageURL = article.imageUrl {
            loadImage(from: imageURL)
        } else {
            newsImageView.image = UIImage(systemName: "person.circle.fill")
            newsImageView.tintColor = .lightGray
        }
    }
    
    func showShimmer() {
        newsImageView.showAnimatedGradientSkeleton()
        titleLabel.showAnimatedGradientSkeleton()
        descriptionLabel.showAnimatedGradientSkeleton()
    }
        
    func hideShimmer() {
        newsImageView.hideSkeleton()
        titleLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
    }
    
    private func loadImage(from url: URL) {
        newsImageView.image = UIImage(systemName: "person.circle.fill")
        newsImageView.tintColor = .lightGray
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.newsImageView.image = image ?? UIImage(systemName: "person.circle.fill")
                }
            }
        }
    }
}
