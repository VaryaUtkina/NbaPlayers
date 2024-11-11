//
//  ViewController.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 11.11.2024.
//

import UIKit

final class MainViewController: UIViewController {

    private lazy var segmentedControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["Players", "Teams"])
        segControl.selectedSegmentIndex = 0
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.selectedSegmentTintColor = .darkOrange
        segControl.backgroundColor = .clear
        segControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return segControl
    }()
    
    private lazy var playersList: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "playerCell")
        return tableView
    }()
    
    private let players = GameStatistic.getGameStatistics()
    
    private let primaryColor = UIColor.screenUP
    private let secondaryColor = UIColor.screenDown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(
            topColor: primaryColor,
            bottomColor: secondaryColor
        )
        view.backgroundColor = .screenUP
        setupNavigationBar()
        setupSubviews(segmentedControl, playersList)
        setConstraints()
    }
    
    // MARK: - UITableViewDataSource

}


// MARK: - Setup UI
private extension MainViewController {
    func setupNavigationBar() {
        title = "NBA Players"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = .screenUP
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

// MARK: -  Setup UI
private extension MainViewController {
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            playersList.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            playersList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            playersList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            playersList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersList.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        cell.backgroundColor = .clear
        var content = cell.defaultContentConfiguration()
        content.text = players[indexPath.row].player.fullName
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Setup Gradient View
extension UIView {
    func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
}

#Preview {
    UINavigationController(rootViewController: MainViewController())
}

