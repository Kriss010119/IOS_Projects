//
//  WishMakerViewController.swift
//  deosinaPW2
//
//  Created by Kriss Osina on 13.10.2025
//

import UIKit

final class WishMakerViewController: UIViewController {
    
    private enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 1
        
        static let red: String = "Red"
        static let blue: String = "Blue"
        static let green: String = "Green"
        
        static let initialRedValue: Float = 0.5
        static let initialBlueValue: Float = 0.5
        static let initialGreenValue: Float = 0.5
        
        static let stackRadius: CGFloat = 20
        static let stackLeading: CGFloat = 5
        
        static let titleTop: CGFloat = 20
        static let titleLeading: CGFloat = 20
        
        static let buttonStackTop: CGFloat = 20
        static let buttonWidth: CGFloat = 100
        
        static let hexFieldHeight: CGFloat = 44
        
        static let spacing: CGFloat = 10
        static let topBottom: CGFloat = 15
        static let rightLeft: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let font: CGFloat = 32
        static let font2: CGFloat = 24
        static let transp1: CGFloat = 0.3
        static let transp2: CGFloat = 0.5
        
        static let buttonHeight: CGFloat = 50
        static let buttonText: String = "Write Down Wish"
        
        static let scheduleButtonText: String = "Calendar"
        static let actionStackSpacing: CGFloat = 16
        static let actionStackBottom: CGFloat = -20
        static let actionStackLeading: CGFloat = 20
    }
    
    private let stack = UIStackView()
    private let hexTextField = UITextField()
    private let img = DecepticonsImage()
    private let addWishButton: UIButton = UIButton(type: .system)
    private var redValue: Float = Constants.initialRedValue
    private var blueValue: Float = Constants.initialBlueValue
    private var greenValue: Float = Constants.initialGreenValue
    private var currentColorMode: ColorInputMode = .rgb
    private let actionStack = UIStackView()
    
    private lazy var toggleImgButton = createButton(title: "Hide img")
    private lazy var toggleRGBButton = createButton(title: "RGB")
    private lazy var toggleHexButton = createButton(title: "HEX")
    
    private lazy var scheduleButton: UIButton = createScheduleButton()
    
    private enum ColorInputMode {
        case rgb, hex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        configureUI()
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
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        button.layer.cornerRadius = Constants.stackRadius
        button.backgroundColor = .black.withAlphaComponent(Constants.transp2)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Constants.borderWidth
        button.setTitleColor(.white, for: .normal)
        config.title = title
        config.baseForegroundColor = .white
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func configureUI() {
        configureTitle()
        configureDecepticonsImage()
        configureToggleButton()
        configureSliders()
        configureHexTextField()
        updateColorInputVisibility()
        configureButtons()
    }
    
    private func configureTitle() {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.shadowColor = .white
        title.shadowOffset = CGSize(width: 1, height: 1)
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
    
    private func configureDecepticonsImage() {
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.widthAnchor.constraint(equalToConstant: 150),
            img.heightAnchor.constraint(equalToConstant: 150),
            img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
    }
    
    private func configureToggleButton() {
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let buttons = [toggleRGBButton, toggleHexButton, toggleImgButton]
        
        for (_, button) in buttons.enumerated() {
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
        }
        
        toggleRGBButton.addTarget(self, action: #selector(switchToRGBMode), for: .touchUpInside)
        toggleHexButton.addTarget(self, action: #selector(switchToHexMode), for: .touchUpInside)
        toggleImgButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        buttonStack.addArrangedSubview(toggleRGBButton)
        buttonStack.addArrangedSubview(toggleHexButton)
        buttonStack.addArrangedSubview(toggleImgButton)
        
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureSliders() {
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        stack.layer.cornerRadius = 16
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
            stack.topAnchor.constraint(equalTo: toggleImgButton.superview!.bottomAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureHexTextField() {
        hexTextField.placeholder = "Enter HEX (e.g., FF5733)"
        hexTextField.borderStyle = .roundedRect
        hexTextField.textAlignment = .center
        hexTextField.font = .systemFont(ofSize: 16)
        hexTextField.translatesAutoresizingMaskIntoConstraints = false
        hexTextField.addTarget(self, action: #selector(hexFieldChanged), for: .editingChanged)
        
        view.addSubview(hexTextField)
        
        NSLayoutConstraint.activate([
            hexTextField.topAnchor.constraint(equalTo: toggleImgButton.superview!.bottomAnchor, constant: 30),
            hexTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hexTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hexTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureButtons() {
        actionStack.axis = .vertical
        actionStack.spacing = 16
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(actionStack)
        
        addWishButton.setTitle(Constants.buttonText, for: .normal)
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        addWishButton.layer.cornerRadius = 15
        addWishButton.layer.shadowColor = UIColor.black.cgColor
        addWishButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addWishButton.layer.shadowOpacity = 0.2
        addWishButton.layer.shadowRadius = 4
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
        
        scheduleButton.setTitle(Constants.scheduleButtonText, for: .normal)
        scheduleButton.backgroundColor = .white
        scheduleButton.setTitleColor(.systemPurple, for: .normal)
        scheduleButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        scheduleButton.layer.cornerRadius = 15
        scheduleButton.layer.shadowColor = UIColor.black.cgColor
        scheduleButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        scheduleButton.layer.shadowOpacity = 0.2
        scheduleButton.layer.shadowRadius = 4
        scheduleButton.addTarget(self, action: #selector(scheduleButtonPressed), for: .touchUpInside)
        
        actionStack.addArrangedSubview(addWishButton)
        actionStack.addArrangedSubview(scheduleButton)
        
        NSLayoutConstraint.activate([
            actionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addWishButton.heightAnchor.constraint(equalToConstant: 50),
            scheduleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        stack.bottomAnchor.constraint(lessThanOrEqualTo: actionStack.topAnchor, constant: -30).isActive = true
    }
    
    private func createScheduleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.scheduleButtonText, for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        return button
    }
    
    private func updateColorInputVisibility() {
        let isRGBMode = currentColorMode == .rgb
        stack.isHidden = !isRGBMode
        hexTextField.isHidden = isRGBMode
        toggleRGBButton.configuration?.baseBackgroundColor = isRGBMode ? .systemPurple : .systemIndigo
        toggleHexButton.configuration?.baseBackgroundColor = isRGBMode ? .systemIndigo : .systemPurple
    }
    
    @objc private func scheduleButtonPressed() {
        let calendarVC = CalendarViewController()
        calendarVC.backgroundColor = view.backgroundColor
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc private func addWishButtonPressed() {
        let wishVC = WishStoringViewController()
        wishVC.backgroundColor = view.backgroundColor
        present(wishVC, animated: true)
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
