//
//  WrittenWishCell.swift
//  deosinaPW3
//
//  Created by Kriss Osina on 05.11.2025.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    
    static let reuseId: String = "WrittenWishCell"
    var onEdit: (() -> Void)?
    
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let radius: CGFloat = 12
        static let offsetV: CGFloat = 6
        static let offsetH: CGFloat = 16
        static let labelOffset: CGFloat = 16
        
        static let labelTextColor: UIColor = .darkGray
        static let labelFont: UIFont = .systemFont(ofSize: 16)
        
        static let editButtonColor: UIColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1.0)
    }
    
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
        label.textColor = Constants.labelTextColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(Constants.editButtonColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap: UIView = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.radius
        wrap.layer.borderWidth = 1
        wrap.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1.0).cgColor
        
        contentView.addSubview(wrap)
        
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(wishLabel)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.backgroundColor = Constants.editButtonColor
        editButton.layer.cornerRadius = Constants.radius
        editButton.setTitleColor(.white, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        wrap.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.offsetV),
            wrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.offsetV),
            wrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offsetH),
            wrap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offsetH),
            
            wishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.labelOffset),
            wishLabel.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -Constants.labelOffset),
            wishLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.labelOffset),
            wishLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -8),
            
            editButton.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.labelOffset),
            editButton.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func editButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.editButton.alpha = 0.7
            self.editButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.editButton.alpha = 1.0
                self.editButton.transform = .identity
            }
        }
        
        onEdit?()
    }
}
