//
//  DecepticonsImage.swift
//  deosinaPW2
//
//  Created by Kriss Osina on 23.09.2025.
//

import UIKit

final class DecepticonsImage: UIView {
    
    private enum Constants {
        static let fromValue: CGFloat = 1.0
        static let toValue: CGFloat = 1.3
        static let top: CGFloat = 50
        static let duration: TimeInterval = 2.5
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Decepticon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        startAnimation()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.top),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
        
    private func startAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = Constants.fromValue
        scaleAnimation.toValue = Constants.toValue
        scaleAnimation.duration = Constants.duration
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
        imageView.layer.add(scaleAnimation, forKey: "scaleAnimation")
    }
}
