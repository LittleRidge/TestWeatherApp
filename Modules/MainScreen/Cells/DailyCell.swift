//
//  DailyCell.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import UIKit

class DailyCell: UICollectionViewCell {
    static let reuseIdentifier = "DailyCell"
    
    let dayLabel = UILabel()
    let iconView = UIImageView()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(temperatureLabel)
        
        dayLabel.font = .systemFont(ofSize: 16.0)
        temperatureLabel.font = .systemFont(ofSize: 16.0)
        temperatureLabel.textAlignment = .right
        iconView.contentMode = .scaleAspectFit
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32.0),
            iconView.heightAnchor.constraint(equalToConstant: 32.0),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
