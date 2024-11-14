//
//  PlayerTableViewCell.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 14.11.2024.
//

import UIKit

final class PlayerTableViewCell: UITableViewCell {
    private lazy var playerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let networkManager = NetworkManager.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews(playerImage, nameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews(playerImage, nameLabel)
        setupConstraints()
    }

    func config(with player: Player) {
        nameLabel.text = player.fullName
        
        playerImage.layer.shadowColor = UIColor.black.cgColor
        playerImage.layer.shadowRadius = 5
        playerImage.layer.shadowOpacity = 0.5
        playerImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        fetchImage(from: player.headshot.href)
    }

    @MainActor
    private func fetchImage(from url: URL) {
        Task {
            do {
                let imageData = try await networkManager.fetchImage(from: url)
                if let image = UIImage(data: imageData) {
                    playerImage.image = image
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
        playerImage.image = UIImage(systemName: "figure.basketball")
        playerImage.tintColor = .darkOrange
    }
    
    private func setupViews(_ views: UIView...) {
        views.forEach { view in
            contentView.addSubview(view)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            playerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            playerImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playerImage.widthAnchor.constraint(equalToConstant: 40),
            playerImage.heightAnchor.constraint(equalTo: playerImage.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: playerImage.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)
        ])
    }
    
}

