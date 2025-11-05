//  CustomSlider.swift
//  deosinaPW2
//
//  Created by Kriss Osina on 23.09.2025.
//

import UIKit

final class CustomSlider: UIView {
    var valueChanged: ((Double) -> Void)?
    
    private let slider = UISlider()
    private let titleView = UILabel()
    
    private enum Constants {
        static let topPadding: CGFloat = 10
        static let bottomPadding: CGFloat = -10
        static let leadingPadding: CGFloat = 20
    }
    
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        for view in [slider, titleView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topPadding),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingPadding),
            
            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.bottomPadding),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingPadding),
        ])
    }
    
    @objc private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
