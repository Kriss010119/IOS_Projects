//
//  AddWishCell.swift
//  deosinaPW3
//
//  Created by Kriss Osina on 05.11.2025.
//

import UIKit

final class AddWishCell: UITableViewCell {
    
    static let reuseId: String = "AddWishCell"
    
    var addWish: ((String) -> Void)?
    
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 12
        static let wrapOffsetV: CGFloat = 8
        static let wrapOffsetH: CGFloat = 16
        static let contentOffset: CGFloat = 16
        static let buttonHeight: CGFloat = 44
        static let textViewHeight: CGFloat = 80
        
        static let textViewBackground: UIColor = .white
        static let textViewTextColor: UIColor = .darkGray
        static let textViewBorderColor: UIColor = UIColor(red: 0.8, green: 0.8, blue: 0.9, alpha: 1.0)
        
        static let buttonColor: UIColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1.0)
        static let buttonDisabledColor: UIColor = .systemGray4
        static let buttonTextColor: UIColor = .white
    }
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = Constants.textViewBackground
        textView.textColor = Constants.textViewTextColor
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Constants.textViewBorderColor.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return textView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Wish", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Constants.buttonTextColor, for: .normal)
        button.backgroundColor = Constants.buttonDisabledColor
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        textView.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap: UIView = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.layer.borderWidth = 1
        wrap.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1.0).cgColor
        
        contentView.addSubview(wrap)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(textView)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        wrap.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.wrapOffsetV),
            wrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.wrapOffsetV),
            wrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.wrapOffsetH),
            wrap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.wrapOffsetH),
            
            textView.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.contentOffset),
            textView.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.contentOffset),
            textView.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.contentOffset),
            textView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),
            
            addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.contentOffset),
            addButton.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.contentOffset),
            addButton.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.contentOffset),
            addButton.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -Constants.contentOffset),
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    private func updateAddButton() {
        let hasText = !(textView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        addButton.isEnabled = hasText
        addButton.backgroundColor = hasText ? Constants.buttonColor : Constants.buttonDisabledColor
    }
    
    @objc private func addButtonTapped() {
        guard let wish = textView.text, !wish.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.addButton.alpha = 0.7
            self.addButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.addButton.alpha = 1.0
                self.addButton.transform = .identity
            }
        }
        
        addWish?(wish)
        textView.text = ""
        textView.resignFirstResponder()
        updateAddButton()
    }
}

extension AddWishCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateAddButton()
    }
}
