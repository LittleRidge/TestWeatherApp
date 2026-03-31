//
//  MainScreenViewController.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    // UI
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let retryButton = UIButton(type: .system)
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    // Services / ViewModel
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLabels()
        setupCollectionView()
        setupRetryButton()
        setupDataSource()
        bindViewModel()
        
        viewModel.load()
    }
    
    // MARK: - UI Setup
    
    private func setupLabels() {
        cityLabel.font = .systemFont(ofSize: 28.0, weight: .bold)
        temperatureLabel.font = .systemFont(ofSize: 48.0, weight: .semibold)
        conditionLabel.font = .systemFont(ofSize: 20.0)
        
        cityLabel.textAlignment = .center
        temperatureLabel.textAlignment = .center
        conditionLabel.textAlignment = .center
        
        [cityLabel, temperatureLabel, conditionLabel, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8.0),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4.0),
            conditionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupRetryButton() {
        retryButton.setTitle("Retry", for: .normal)
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16.0)
        ])
    }
    
    @objc private func didTapRetry() {
        viewModel.load()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 16.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reuseIdentifier)
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch Section(rawValue: sectionIndex)! {
            case .hourly:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(60.0), heightDimension: .absolute(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(60.0), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0)
                return section
                
            case .daily:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60.0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 4
                section.contentInsets = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
                return section
            }
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, item in
            switch Section(rawValue: indexPath.section)! {
            case .hourly:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.reuseIdentifier, for: indexPath) as! HourlyCell
                if let model = item as? HourlyForecastModel {
                    cell.timeLabel.text = model.time
                    cell.temperatureLabel.text = model.temperature
                    if let url = model.iconURL { cell.imageView.load(url: url) }
                }
                return cell
                
            case .daily:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCell.reuseIdentifier, for: indexPath) as! DailyCell
                if let model = item as? DailyForecastModel {
                    cell.dayLabel.text = model.day
                    cell.temperatureLabel.text = "\(model.minTemperature)/\(model.maxTemperature)"
                    if let url = model.iconURL { cell.iconView.load(url: url) }
                }
                return cell
            }
        }
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async { self?.render(state) }
        }
    }
    
    private func render(_ state: MainViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            retryButton.isHidden = true
            collectionView.isHidden = true
            cityLabel.text = ""
            temperatureLabel.text = ""
            conditionLabel.text = ""
            
        case let .loaded(city, temp, condition, hourly, daily):
            activityIndicator.stopAnimating()
            retryButton.isHidden = true
            collectionView.isHidden = false
            cityLabel.text = city
            temperatureLabel.text = temp
            conditionLabel.text = condition
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snapshot.appendSections([.hourly, .daily])
            snapshot.appendItems(hourly, toSection: .hourly)
            snapshot.appendItems(daily, toSection: .daily)
            dataSource.apply(snapshot, animatingDifferences: true)
            
        case .error:
            activityIndicator.stopAnimating()
            retryButton.isHidden = false
            collectionView.isHidden = true
            cityLabel.text = "Error"
            temperatureLabel.text = "--"
            conditionLabel.text = "Failed to load"
        }
    }
}

// MARK: - Sections
enum Section: Int, CaseIterable {
    case hourly
    case daily
}

// MARK: - UIImageView Extension

extension UIImageView {
    func load(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
