//
//  HourlyCell.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import UIKit

class HourlyCell: UICollectionViewCell {
    static let reuseIdentifier = "HourlyCell"
    
    let timeLabel = UILabel()
    let imageView = UIImageView()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(temperatureLabel)
        
        timeLabel.font = .systemFont(ofSize: 14.0)
        timeLabel.textAlignment = .center
        
        temperatureLabel.font = .systemFont(ofSize: 16.0)
        temperatureLabel.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFit
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4.0),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 32.0),
            imageView.heightAnchor.constraint(equalToConstant: 32.0),
            
            temperatureLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4.0),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
