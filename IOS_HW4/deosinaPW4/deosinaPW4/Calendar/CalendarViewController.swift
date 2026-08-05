import UIKit

final class CalendarViewController: UIViewController {
    
    var backgroundColor: UIColor?
    
    private enum Constants {
        static let contentInset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let collectionTop: CGFloat = 16
        static let cellHeight: CGFloat = 160
        static let buttonSize: CGFloat = 44
        static let buttonPadding: CGFloat = 16
        static let eventsKey: String = "calendar_events"
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var events: [CalendarEventModel] = []
    private let defaults = UserDefaults.standard
    private let calendarManager = CalendarManager()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1.0)
        button.layer.cornerRadius = Constants.buttonSize / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No events\nTap + to create your first event ^v^"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollection()
        loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEvents()
    }
    
    private func configureUI() {
        view.backgroundColor = backgroundColor ?? UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1.0)
        title = "Wish Calendar"
        
        view.addSubview(addButton)
        view.addSubview(emptyStateLabel)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonPadding),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonPadding),
            addButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            addButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset
        collectionView.isUserInteractionEnabled = true
        
        collectionView.register(
            CalendarEventCell.self,
            forCellWithReuseIdentifier: CalendarEventCell.reuseIdentifier
        )
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.bringSubviewToFront(addButton)
    }
    
    private func updateEmptyState() {
        let isEmpty = events.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
    private func saveEvents() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(events) {
            defaults.set(encoded, forKey: Constants.eventsKey)
        }
    }
    
    private func loadEvents() {
        if let savedData = defaults.data(forKey: Constants.eventsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([CalendarEventModel].self, from: savedData) {
                events = decoded
                collectionView.reloadData()
                updateEmptyState()
            }
        } else {
            updateEmptyState()
        }
    }
    
    private func createCalendarEvent(from wishEvent: CalendarEventModel, completion: ((Bool) -> Void)? = nil) {
        calendarManager.create(eventModel: wishEvent) { success in
            DispatchQueue.main.async {
                if success {
                    if let completion = completion {
                        completion(true)
                    }
                } else {
                    if let completion = completion {
                        completion(false)
                    }
                }
            }
        }
    }
    
    private func deleteCalendarEvent(for eventId: String) {
        calendarManager.delete(eventId: eventId) { _ in }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func addButtonTapped() {
        let creationVC = CalendarEventCreationViewController()
        creationVC.modalPresentationStyle = .fullScreen
        
        creationVC.onEventCreated = { [weak self] event in
            self?.events.append(event)
            self?.saveEvents()
            self?.collectionView.reloadData()
            self?.updateEmptyState()
            self?.createCalendarEvent(from: event)
        }
        
        present(creationVC, animated: true)
    }
    
    private func showEventDetails(_ event: CalendarEventModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let alert = UIAlertController(
            title: "Event Details",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let message = """
        Title: \(event.title)
        
        Description: \(event.description)
        
        Start: \(dateFormatter.string(from: event.startDate))
        End: \(dateFormatter.string(from: event.endDate))
        
        \(event.wishTitle.map { "Wish: \($0)" } ?? "No wish")
        """
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .darkGray
        
        let container = UIViewController()
        container.view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: container.view.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: container.view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: container.view.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: container.view.bottomAnchor, constant: -20)
        ])
        
        alert.setValue(container, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            self?.editEvent(event)
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.showDeleteConfirmation(for: event)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - EditEvent
    
    private func editEvent(_ event: CalendarEventModel) {
        let creationVC = CalendarEventCreationViewController()
        creationVC.modalPresentationStyle = .fullScreen
        
        creationVC.setupForEditing(event: event)
        
        creationVC.onEventUpdated = { [weak self] updatedEvent in
            if let index = self?.events.firstIndex(where: { $0.id == event.id }) {
                let updatedWithCalendarId = CalendarEventModel(
                    id: event.id,
                    title: updatedEvent.title,
                    description: updatedEvent.description,
                    startDate: updatedEvent.startDate,
                    endDate: updatedEvent.endDate,
                    wishTitle: updatedEvent.wishTitle,
                    calendarEventId: event.calendarEventId
                )
                
                self?.events[index] = updatedWithCalendarId
                self?.saveEvents()
                self?.collectionView.reloadData()
            }
        }
        
        present(creationVC, animated: true)
    }
    
    // MARK: - Show Details Confirmation
    
    private func showDeleteConfirmation(for event: CalendarEventModel) {
        let alert = UIAlertController(
            title: "Delete Event",
            message: "Are you sure you want to delete \"\(event.title)\"?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteEvent(event)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func deleteEvent(_ event: CalendarEventModel) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
            saveEvents()
            
            deleteCalendarEvent(for: event.id)
            
            collectionView.reloadData()
            updateEmptyState()
            
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
            
            showAlert(title: "Deleted", message: "Event has been deleted")
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarEventCell.reuseIdentifier,
            for: indexPath
        ) as! CalendarEventCell
        
        cell.configure(with: events[indexPath.item])
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - Constants.contentInset.left - Constants.contentInset.right
        return CGSize(width: width, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.item]
        showEventDetails(event)
    }
}
