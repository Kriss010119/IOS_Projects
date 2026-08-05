//
//  WishStoringViewController.swift
//  deosinaPW3
//
//  Created by Kriss Osina on 05.11.2025.
//


import UIKit

final class WishStoringViewController: UIViewController {
    
    private let table: UITableView = UITableView(frame: .zero)
    private var wishArray: [String] = []
    private let defaults = UserDefaults.standard
    
    var backgroundColor: UIColor?
    
    private enum Constants {
        static let tableOffset: CGFloat = 16
        static let tableCornerRadius: CGFloat = 12
        static let wishKey: String = "wishes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1.0)
        configureTable()
        loadWishes()
    }
    
    private func configureTable() {
        view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.tableOffset),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tableOffset),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.tableOffset),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.tableOffset)
        ])
    }
    
    private func saveWishes() {
        defaults.set(wishArray, forKey: Constants.wishKey)
    }
    
    private func loadWishes() {
        if let savedWishes = defaults.array(forKey: Constants.wishKey) as? [String] {
            wishArray = savedWishes
        }
    }
    
    private func addWish(_ wish: String) {
        guard !wish.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        wishArray.append(wish)
        saveWishes()
        table.reloadData()
    }
    
    private func editWish(at index: Int, newText: String) {
        guard index < wishArray.count else { return }
        guard !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        wishArray[index] = newText
        saveWishes()
        table.reloadData()
    }
    
    private func showEditAlert(for wishText: String, currentIndex: Int) {
        let alert = UIAlertController(title: "Edit Wish", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = wishText
            textField.placeholder = "Input your wish"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self, let newText = alert.textFields?.first?.text else { return }
            if let actualIndex = self.wishArray.firstIndex(of: wishText) {
                self.editWish(at: actualIndex, newText: newText)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return wishArray.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddWishCell.reuseId,
                for: indexPath
            )
            guard let addWishCell = cell as? AddWishCell else { return cell }
            addWishCell.addWish = { [weak self] wish in
                self?.addWish(wish)
            }
            return addWishCell
            
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WrittenWishCell.reuseId,
                for: indexPath
            )
            guard let wishCell = cell as? WrittenWishCell else { return cell }
            let wishText = wishArray[indexPath.row]
            wishCell.configure(with: wishText)
            wishCell.onEdit = { [weak self] in
                self?.showEditAlert(for: wishText, currentIndex: indexPath.row)
            }
            return wishCell
            
        default:
            return UITableViewCell()
        }
    }
}

extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 1 {
            wishArray.remove(at: indexPath.row)
            saveWishes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
}
