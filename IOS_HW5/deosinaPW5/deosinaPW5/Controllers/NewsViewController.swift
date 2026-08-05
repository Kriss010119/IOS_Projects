//
//  NewsViewController.swift
//  deosinaPW5
//
//  Created by Kriss Osina on 9.02.2026.
//

import UIKit

class NewsViewController: UIViewController {

    // MARK: - Variables
    private let tableView = UITableView()
    private let viewModel = NewsViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
        setupViewModel()
        viewModel.loadNews()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    private func setupViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                print("Table view updated with \(self?.viewModel.articles.count ?? 0) items")
            }
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
}

// MARK: - Extensions
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        
        cell.showShimmer()
        
        let article = viewModel.articles[indexPath.row]
        cell.configure(with: article)
        cell.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.hideShimmer()
        }
        
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = viewModel.articles[indexPath.row]
        let detailVC = CharacterDetailViewController(character: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let article = viewModel.articles[indexPath.row]
        let shareAction = UIContextualAction(style: .normal, title: "Поделиться") { [weak self] (_, _, completion) in
            self?.showShareOptions(for: article)
            completion(true)
        }
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        let configuration = UISwipeActionsConfiguration(actions: [shareAction])
        configuration.performsFirstActionWithFullSwipe = false // Отключаем полный свайп
        return configuration
    }
    
    private func showShareOptions(for article: ArticleModel) {
        let alertController = UIAlertController(
            title: "Поделиться",
            message: "Выберите способ",
            preferredStyle: .actionSheet
        )
        let vkAction = UIAlertAction(title: "VK", style: .default) { _ in
            VK.shared.shareToVK(article: article, from: self)
        }
        let moreAction = UIAlertAction(title: "Ещё", style: .default) { _ in
            VK.shared.shareViaSystemSheet(article: article, from: self)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(vkAction)
        alertController.addAction(moreAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: - Delegate
extension NewsViewController: ArticleCellDelegate {
    func shareButtonTapped(for article: ArticleModel) {
        showShareOptions(for: article)
    }
}
