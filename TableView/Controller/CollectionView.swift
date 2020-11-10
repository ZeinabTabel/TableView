//
//  CollectionView.swift
//  TableView
//
//  Created by Zeinab on 11/10/20.
//  Copyright © 2020 Zeinab. All rights reserved.
//

import UIKit

class CollectionView: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [Photos] = []
    let refresh = UIRefreshControl()
    let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 25.0,
                                             left: 10.0,
                                             bottom: 25.0,
                                             right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPhotos()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nibCollection(), forCellWithReuseIdentifier: CollectionViewCell.collectionCell)
        collectionView.refreshControl = refresh
        refresh.addTarget(self,
                          action: #selector(refreshPhotos),
                          for:.valueChanged)
    }
    
    @objc func refreshPhotos (_ sender:Any) {
        getPhotos()
    }
    
    func getPhotos() {
        guard let url = URL(string:"https://jsonplaceholder.typicode.com/photos?albumId=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.refresh.endRefreshing()
            }
            guard let jsonData = data , error == nil else {
                print("error!")
                return
            }
            do {
                let photos = try JSONDecoder().decode([Photos].self, from: jsonData)
                DispatchQueue.main.async {
                    self.photos = photos
                    self.collectionView.reloadData()
                    
                }
            }
            catch {
                print("Error \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
}

extension CollectionView: UICollectionViewDataSource {
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.collectionCell,
                                                         for: indexPath) as? CollectionViewCell {
            cell.configure(imageUrl: photos[indexPath.item].thumbnailUrl)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension CollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
