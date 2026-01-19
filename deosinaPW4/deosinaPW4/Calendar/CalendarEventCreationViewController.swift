//
//  CalendarEventCreationViewController.swift
//  deosinaPW4
//
//  Created by Kriss Osina on 18.01.2026.
//

import UIKit

final class CalendarEventCreationViewController: UIViewController {
    
    var onEventCreated: ((CalendarEventModel) -> Void)?
    var onEventUpdated: ((CalendarEventModel) -> Void)?
    
    private var wishes: [String] = []
    private let defaults = UserDefaults.standard
    private var selectedWish: String?
    private var isEditingMode = false
    private var editingEvent: CalendarEventModel?
    
    private enum Constants {
        static let contentInset: CGFloat = 16
        static let fieldHeight: CGFloat = 44
        static let spacing: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let textViewHeight: CGFloat = 100
        static let wishKey: String = "wishes"
    }
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Event Title"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return textView
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = Date()
        return picker
    }()
    
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = Date().addingTimeInterval(3600)
        return picker
    }()
    
    private lazy var wishSelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select a wish", for: .normal)
        button.setTitleColor(.systemPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.addTarget(self, action: #selector(showWishSelection), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        loadWishes()
        setupKeyboardDismissal()
    }
    
    func setupForEditing(event: CalendarEventModel) {
        isEditingMode = true
        editingEvent = event
        
        titleTextField.text = event.title
        descriptionTextView.text = event.description
        startDatePicker.date = event.startDate
        endDatePicker.date = event.endDate
        endDatePicker.minimumDate = event.startDate.addingTimeInterval(3600)
        
        if let wishTitle = event.wishTitle {
            selectedWish = wishTitle
            wishSelectionButton.setTitle("Selected: \(wishTitle)", for: .normal)
        }
        
        actionButton.setTitle("Update Event", for: .normal)
        title = "Edit Event"
    }
    
    
    private func configureUI() {
        if !isEditingMode {
            title = "New Event"
            actionButton.setTitle("Create Event", for: .normal)
        }
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let startDateLabel = UILabel()
        startDateLabel.text = "Start Date"
        startDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let endDateLabel = UILabel()
        endDateLabel.text = "End Date"
        endDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let wishLabel = UILabel()
        wishLabel.text = "Wish"
        wishLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let cancelButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Cancel", for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            return button
        }()
        
        let fields = [
            titleLabel, titleTextField,
            descriptionLabel, descriptionTextView,
            startDateLabel, startDatePicker,
            endDateLabel, endDatePicker,
            wishLabel, wishSelectionButton,
            actionButton, cancelButton
        ]
        
        fields.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        [titleLabel, titleTextField, descriptionLabel, descriptionTextView,
         startDateLabel, startDatePicker, endDateLabel, endDatePicker,
         wishLabel, wishSelectionButton,
         actionButton, cancelButton].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30), // Небольшой отступ сверху
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.fieldHeight),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Constants.spacing * 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.spacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            descriptionTextView.heightAnchor.constraint(equalToConstant: Constants.textViewHeight),
            
            startDateLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: Constants.spacing * 2),
            startDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            startDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            
            startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: Constants.spacing),
            startDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            startDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            
            endDateLabel.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: Constants.spacing * 2),
            endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            endDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            
            endDatePicker.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: Constants.spacing),
            endDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            endDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            
            wishLabel.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: Constants.spacing * 2),
            wishLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            wishLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            
            wishSelectionButton.topAnchor.constraint(equalTo: wishLabel.bottomAnchor, constant: Constants.spacing),
            wishSelectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            wishSelectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            wishSelectionButton.heightAnchor.constraint(equalToConstant: Constants.fieldHeight),
            
            cancelButton.topAnchor.constraint(equalTo: wishSelectionButton.bottomAnchor, constant: Constants.spacing * 2),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.fieldHeight),
            
            actionButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: Constants.spacing * 2),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInset),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInset),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentInset)
        ])
    }
    
    private func loadWishes() {
        if let savedWishes = defaults.array(forKey: Constants.wishKey) as? [String] {
            wishes = savedWishes
        }
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func showWishSelection() {
        let alert = UIAlertController(
            title: "Select a Wish",
            message: "Choose a wish from your saved list",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "None", style: .default) { [weak self] _ in
            self?.clearWishSelection()
        })
        
        for wish in wishes {
            alert.addAction(UIAlertAction(title: wish, style: .default) { [weak self] _ in
                self?.selectedWish = wish
                self?.wishSelectionButton.setTitle("Selected: \(wish)", for: .normal)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func clearWishSelection() {
        selectedWish = nil
        wishSelectionButton.setTitle("Select a wish", for: .normal)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func actionButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "Error", message: "Please enter event title :)")
            return
        }
        
        guard let description = descriptionTextView.text, !description.isEmpty else {
            showAlert(title: "Error", message: "Please enter event description :)")
            return
        }
        
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        if endDate <= startDate {
            showAlert(title: "Error", message: "End date must be after start date :)")
            return
        }
        
        if isEditingMode, let originalEvent = editingEvent {
            let updatedEvent = CalendarEventModel(
                id: originalEvent.id,
                title: title,
                description: description,
                startDate: startDate,
                endDate: endDate,
                wishTitle: selectedWish,
                calendarEventId: originalEvent.calendarEventId
            )
            
            onEventUpdated?(updatedEvent)
            dismiss(animated: true)
        } else {
            let event = CalendarEventModel(
                title: title,
                description: description,
                startDate: startDate,
                endDate: endDate,
                wishTitle: selectedWish
            )
            
            onEventCreated?(event)
            dismiss(animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
