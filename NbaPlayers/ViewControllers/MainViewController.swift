//
//  ViewController.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 11.11.2024.
//

import UIKit

final class MainViewController: UIViewController {

    private lazy var segmentedControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["Teams", "Players"])
        segControl.selectedSegmentIndex = 0
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.selectedSegmentTintColor = .darkOrange
        segControl.backgroundColor = .clear
        segControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return segControl
    }()
    
    private lazy var nbaTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "playerCell")
        return tableView
    }()
    
    private var teams: [Team] = []
    private let networkManager = NetworkManager.shared
    
    private let primaryColor = UIColor.screenUP
    private let secondaryColor = UIColor.screenDown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(
            topColor: primaryColor,
            bottomColor: secondaryColor
        )
        view.backgroundColor = .screenUP
        nbaTableView.rowHeight = 60
        setupNavigationBar()
        setupSubviews(segmentedControl, nbaTableView)
        setConstraints()
        fetchTeams()
    }
    
    func fetchTeams() {
        networkManager.fetchTeams(
            with: NSURL(string: "https://sports-information.p.rapidapi.com/nba/team-list")!
        ) { result in
            switch result {
            case .success(let teams):
                self.teams = teams
                DispatchQueue.main.async { [unowned self] in
                    nbaTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

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
            nbaTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            nbaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nbaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            nbaTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = nbaTableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        guard let cell = tableCell as? TeamTableViewCell else { return UITableViewCell() }
        let team = teams[indexPath.row]
        cell.backgroundColor = .clear
        cell.config(with: team)
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
//
//#Preview {
//    UINavigationController(rootViewController: MainViewController())
//}

