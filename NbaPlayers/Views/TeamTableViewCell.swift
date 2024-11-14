//
//  TeamTableViewCell.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 12.11.2024.
//

import UIKit

final class TeamTableViewCell: UITableViewCell {
    private lazy var teamImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var teamLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let networkManager = NetworkManager.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews(teamImage, teamLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews(teamImage, teamLabel)
        setupConstraints()
    }

    func config(with team: Team) {
        teamLabel.text = team.displayName
        
        teamImage.layer.shadowColor = UIColor(hex: team.color)?.cgColor
        teamImage.layer.shadowRadius = 5
        teamImage.layer.shadowOpacity = 0.5
        teamImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        if let logoURL = team.logos.first?.href {
            fetchImage(from: logoURL)
        } else {
            setDefaultImage()
        }
    }

    @MainActor
    private func fetchImage(from url: URL) {
        Task {
            do {
                let imageData = try await networkManager.fetchImage(from: url)
                if let image = UIImage(data: imageData) {
                    teamImage.image = image
                } else {
                    setDefaultImage()
                }
            } catch {
                setDefaultImage()
                print(error)
            }
        }
    }
    
    private func setDefaultImage() {
        teamImage.image = UIImage(systemName: "basketball.circle")
        teamImage.tintColor = .darkOrange
    }
    
    private func setupViews(_ views: UIView...) {
        views.forEach { view in
            contentView.addSubview(view)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            teamImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            teamImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            teamImage.widthAnchor.constraint(equalToConstant: 40),
            teamImage.heightAnchor.constraint(equalTo: teamImage.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            teamLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            teamLabel.leadingAnchor.constraint(equalTo: teamImage.trailingAnchor, constant: 8),
            teamLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)
        ])
    }
    
}


