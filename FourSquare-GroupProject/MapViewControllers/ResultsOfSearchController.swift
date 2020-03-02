//
//  ResultsOfSearchController.swift
//  FourSquare-GroupProject
//
//  Created by Juan Ceballos on 2/21/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import DataPersistence

class ResultsOfSearchController: UIViewController {
    
    let dataPersistence: DataPersistence<AlbumCollection>

    private let searchResultView = SearchResultsView()
    private var searchResults = [Venue]()

    
    init(_ dataPersistence:DataPersistence<AlbumCollection>, _ venues: [Venue]) {
        self.dataPersistence = dataPersistence
        searchResults = venues
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coser:) has  not been implemented")
    }

    
    override func loadView() {
        view = searchResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmptyView()
        view.backgroundColor = .systemTeal
        navigationItem.title = "Search Results"
        searchResultView.collectionView.register(SearchResultsCell.self, forCellWithReuseIdentifier: "searchResultCell")
        searchResultView.collectionView.dataSource = self
        searchResultView.collectionView.delegate = self
    }
    
    private func loadEmptyView() {
        if self.searchResults.isEmpty {
            self.searchResultView.collectionView.backgroundView = EmptyView(title: "Oops!", message: "You did not search yet!\n Go back to the Map and try again!")
            self.searchResultView.collectionView.backgroundView?.backgroundColor = .systemPurple
            
        } else {
            self.searchResultView.collectionView.backgroundView = nil
        }
        
    }
    

}
extension ResultsOfSearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResultCell", for: indexPath) as? SearchResultsCell else {
            fatalError("could not downcast to SearchResultsCell")
        }
        let venue = searchResults[indexPath.row]
        cell.backgroundColor = .systemBackground
        cell.configureCell(for: venue)
        return cell
    }

}
extension ResultsOfSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.9
        let itemHeight: CGFloat = maxSize.height * 0.15
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("venue selected")
        let selectedVenue = searchResults[indexPath.row]
        
        let detailVC = RestaurantsDetailController(dataPersistence, selectedVenue)
       // let adetailVC = UINavigationController(rootViewController: detailVC)
        //present(adetailVC,animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
