//  WishMakerViewController.swift
//  deosinaPW2
//
//  Created by Kriss Osina on 22.09.2025.
//

import UIKit

final class WishMakerViewController: UIViewController {
    
    private let stack = UIStackView()
    private let hexTextField = UITextField()
    private let img = DecepticonsImage()
    
    private var redValue: Float = 0.5
    private var blueValue: Float = 0.5
    private var greenValue: Float = 0.5
    private var currentColorMode: ColorInputMode = .rgb
    
    private lazy var toggleImgButton = createButton(title: "Hide img")
    private lazy var toggleRGBButton = createButton(title: "RGB")
    private lazy var toggleHexButton = createButton(title: "HEX")
    
    private enum ColorInputMode {
        case rgb, hex
    }
    
    private enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        
        static let red: String = "Red"
        static let blue: String = "Blue"
        static let green: String = "Green"
        
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = -40
        static let stackLeading: CGFloat = 20
        
        static let titleTop: CGFloat = 30
        static let titleLeading: CGFloat = 20
        
        static let imageTop: CGFloat = 80
        static let imageLeading: CGFloat = 80
        static let imageSize: CGFloat = 200
        
        static let buttonStackTop: CGFloat = 50
        static let buttonWidth: CGFloat = 100
        
        static let hexFieldBottom: CGFloat = -100
        static let hexFieldHeight: CGFloat = 40
        
        static let spacing: CGFloat = 10
        static let topBottom: CGFloat = 15
        static let rightLeft: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let font: CGFloat = 32
        static let font2: CGFloat = 24
        static let textWidth: CGFloat = 300
        static let transp1: CGFloat = 0.3
        static let transp2: CGFloat = 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        configureUI()
    }
    
    private func configureUI() {
        configureTitle()
        configureSliders()
        configureHexTextField()
        configureDecepticonsImage()
        configureToggleButton()
        configureExtraInfoLabel()
        updateColorInputVisibility()
    }
    
    private func configureTitle() {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.backgroundColor = .black.withAlphaComponent(Constants.transp1)
        title.layer.cornerRadius = Constants.stackRadius
        title.textAlignment = .center
        title.clipsToBounds = true
        title.text = "WishMaker"
        title.font = UIFont.systemFont(ofSize: Constants.font)

        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleLeading),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTop)
        ])
    }
    
    private func configureToggleButton() {
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = Constants.spacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        toggleImgButton.setTitle("Hide img", for: .normal)
        toggleImgButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth).isActive = true
        toggleRGBButton.setTitle("RGB", for: .normal)
        toggleHexButton.setTitle("HEX", for: .normal)
        
        toggleRGBButton.addTarget(self, action: #selector(switchToRGBMode), for: .touchUpInside)
        toggleHexButton.addTarget(self, action: #selector(switchToHexMode), for: .touchUpInside)
        toggleImgButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        buttonStack.addArrangedSubview(toggleRGBButton)
        buttonStack.addArrangedSubview(toggleHexButton)
        buttonStack.addArrangedSubview(toggleImgButton)
        
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: img.bottomAnchor, constant: Constants.buttonStackTop),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureDecepticonsImage() {
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.imageLeading),
            img.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            img.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.imageTop)
        ])
    }
    
    private func configureExtraInfoLabel() {
        let extraInfoLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: Constants.font2, weight: .medium)
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = "Use the sliders to adjust the color of the Decepticon's armor."
            return label
        }()
        extraInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(extraInfoLabel)
        
        NSLayoutConstraint.activate([
            extraInfoLabel.topAnchor.constraint(equalTo: toggleImgButton.bottomAnchor, constant: Constants.titleTop),
            extraInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            extraInfoLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.textWidth)
        ])
    }
    
    private func configureSliders() {
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        stack.layer.cornerRadius = Constants.stackRadius
        stack.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        
        sliderRed.valueChanged = { [weak self] value in
            self?.redValue = Float(value)
            self?.updateBackgroundColor()
        }
        
        sliderGreen.valueChanged = { [weak self] value in
            self?.greenValue = Float(value)
            self?.updateBackgroundColor()
        }
        
        sliderBlue.valueChanged = { [weak self] value in
            self?.blueValue = Float(value)
            self?.updateBackgroundColor()
        }
        
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            stack.addArrangedSubview(slider)
        }
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackLeading),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackBottom)
        ])
    }
    
    private func configureHexTextField() {
        hexTextField.placeholder = "Введите HEX (например: FF5733)"
        hexTextField.borderStyle = .roundedRect
        hexTextField.textAlignment = .center
        hexTextField.translatesAutoresizingMaskIntoConstraints = false
        hexTextField.addTarget(self, action: #selector(hexFieldChanged), for: .editingChanged)
        
        view.addSubview(hexTextField)
        
        NSLayoutConstraint.activate([
            hexTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            hexTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackLeading),
            hexTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.hexFieldBottom),
            hexTextField.heightAnchor.constraint(equalToConstant: Constants.hexFieldHeight)
        ])
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        
        button.layer.cornerRadius = Constants.stackRadius
        button.backgroundColor = .black.withAlphaComponent(Constants.transp2)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Constants.borderWidth
        button.setTitleColor(.white, for: .normal)
        
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: Constants.topBottom, leading: Constants.rightLeft, bottom: Constants.topBottom, trailing: Constants.rightLeft)
        config.baseForegroundColor = .white
        button.configuration = config
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func updateColorInputVisibility() {
        let isRGBMode = currentColorMode == .rgb
        stack.isHidden = !isRGBMode
        hexTextField.isHidden = isRGBMode
        toggleRGBButton.configuration?.baseBackgroundColor = isRGBMode ? .systemPurple : .systemIndigo
        toggleHexButton.configuration?.baseBackgroundColor = isRGBMode ? .systemIndigo : .systemPurple
    }
    
    private func updateBackgroundColor() {
        let color = UIColor(
            red: CGFloat(redValue),
            green: CGFloat(greenValue),
            blue: CGFloat(blueValue),
            alpha: 1.0
        )
        view.backgroundColor = color
    }
    
    @objc private func toggleButtonTapped() {
        img.isHidden.toggle()
        toggleImgButton.setTitle(img.isHidden ? "Show img" : "Hide img", for: .normal)
    }
    
    @objc private func hexFieldChanged() {
        guard let hexText = hexTextField.text, !hexText.isEmpty else { return }
        
        let color = UIColor.fromHex(hexText)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        redValue = Float(red)
        greenValue = Float(green)
        blueValue = Float(blue)
        updateBackgroundColor()
    }

    @objc private func switchToRGBMode() {
        currentColorMode = .rgb
        updateColorInputVisibility()
    }

    @objc private func switchToHexMode() {
        currentColorMode = .hex
        updateColorInputVisibility()
    }
}
