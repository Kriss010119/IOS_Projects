//
//  CalendarEventCell.swift
//  deosinaPW4
//
//  Created by Kriss Osina on 17.01.2026.
//
import UIKit

final class CalendarEventCell: UICollectionViewCell {
    static let reuseIdentifier = "CalendarEventCell"
    
    private enum Constants {
        static let offset: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let titleTop: CGFloat = 12
        static let titleLeading: CGFloat = 12
        static let spacing: CGFloat = 8
        static let fontSize: CGFloat = 14
        
        static let wrapColor: UIColor = .white
        static let titleColor: UIColor = .black
        static let textColor: UIColor = .darkGray
    }
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.wrapColor
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.fontSize + 2)
        label.textColor = Constants.titleColor
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.fontSize)
        label.textColor = Constants.textColor
        label.numberOfLines = 2
        return label
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.fontSize - 2)
        label.textColor = Constants.textColor
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.fontSize - 2)
        label.textColor = Constants.textColor
        return label
    }()
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.fontSize - 2)
        label.textColor = Constants.textColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    func configure(with event: CalendarEventModel) {
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        startDateLabel.text = "From: \(dateFormatter.string(from: event.startDate))"
        endDateLabel.text = "To: \(dateFormatter.string(from: event.endDate))"
        
        if let wishTitle = event.wishTitle {
            wishLabel.text = "Wish: \(wishTitle)"
            wishLabel.isHidden = false
        } else {
            wishLabel.isHidden = true
        }
    }
    
    private func configureUI() {
        backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(descriptionLabel)
        backView.addSubview(startDateLabel)
        backView.addSubview(endDateLabel)
        backView.addSubview(wishLabel)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.offset),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.offset),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset),
            
            titleLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: Constants.titleTop),
            titleLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Constants.titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Constants.titleLeading),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Constants.titleLeading),
            descriptionLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Constants.titleLeading),
            
            wishLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.spacing),
            wishLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Constants.titleLeading),
            wishLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Constants.titleLeading),
            
            startDateLabel.topAnchor.constraint(equalTo: wishLabel.bottomAnchor, constant: Constants.spacing),
            startDateLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Constants.titleLeading),
            startDateLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Constants.titleLeading),
            
            endDateLabel.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: Constants.spacing/2),
            endDateLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Constants.titleLeading),
            endDateLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Constants.titleLeading),
        ])
    }
}
