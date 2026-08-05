//
//  CharacterDetailViewController.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import UIKit
import SkeletonView

class CharacterDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let filmsTitleLabel = UILabel()
    private let filmsLabel = UILabel()
    private let tvShowsTitleLabel = UILabel()
    private let tvShowsLabel = UILabel()
    
    // MARK: - Properties
    private var character: ArticleModel
    
    // MARK: - Init
    init(character: ArticleModel) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        loadImage()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = character.name
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [filmsTitleLabel, tvShowsTitleLabel].forEach {
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textColor = .systemPurple
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [filmsLabel, tvShowsLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(filmsTitleLabel)
        contentView.addSubview(filmsLabel)
        contentView.addSubview(tvShowsTitleLabel)
        contentView.addSubview(tvShowsLabel)
        
        filmsTitleLabel.text = "Films"
        tvShowsTitleLabel.text = "TV Shows"
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            filmsTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            filmsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filmsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            filmsLabel.topAnchor.constraint(equalTo: filmsTitleLabel.bottomAnchor, constant: 8),
            filmsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filmsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tvShowsTitleLabel.topAnchor.constraint(equalTo: filmsLabel.bottomAnchor, constant: 20),
            tvShowsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tvShowsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tvShowsLabel.topAnchor.constraint(equalTo: tvShowsTitleLabel.bottomAnchor, constant: 8),
            tvShowsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tvShowsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureUI() {
        nameLabel.text = character.name
        filmsLabel.text = character.films.isEmpty ? "No films" : character.films.joined(separator: "\n ")
        tvShowsLabel.text = character.tvShows.isEmpty ? "No TV shows" : character.tvShows.joined(separator: "\n ")
    }
    
    private func loadImage() {
        imageView.showAnimatedGradientSkeleton()
        
        guard let imageURL = character.imageUrl else {
            imageView.hideSkeleton()
            imageView.image = UIImage(systemName: "person.circle.fill")
            imageView.tintColor = .lightGray
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imageView.hideSkeleton()
                    self?.imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.imageView.hideSkeleton()
                    self?.imageView.image = UIImage(systemName: "person.circle.fill")
                    self?.imageView.tintColor = .lightGray
                }
            }
        }
    }
}
