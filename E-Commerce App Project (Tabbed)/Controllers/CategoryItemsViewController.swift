//
//  CategoryItemsViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import UIKit

class CategoryItemsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private(set) var categoryItemsList: [Item] = []
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    var receivedCategoryItemsList: [Item] = []
    var receivedCategoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryItemsList = receivedCategoryItemsList
        categoryName.text = receivedCategoryName
        navigationItem.title = receivedCategoryName
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let individualData = categoryItemsList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath)
        
        if let itemImage = cell.viewWithTag(1001) as? UIImageView,
           let itemName = cell.viewWithTag(1002) as? UILabel,
           let itemPrice = cell.viewWithTag(1003) as? UILabel {
            if let url = URL(string: individualData.photoURL),
               let data = try? Data(contentsOf: url) {
                itemImage.image = UIImage(data: data)
            }
            itemName.text = individualData.itemName
            itemPrice.text = showPrice(individualData.price)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItemsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }
        
        let individualData = categoryItemsList[indexPath.row]
        
        singleItemView.itemObjectReceived = individualData
        
        if let url = URL(string: individualData.photoURL),
           let data = try? Data(contentsOf: url) {
            singleItemView.setItemImage = data
        }
        singleItemView.setItemName = individualData.itemName
        singleItemView.setItemCategory = individualData.itemCategory
        singleItemView.setItemID = individualData.ID
        singleItemView.setItemPrice = NSNumber(value: individualData.price)
        singleItemView.setItemBrand = individualData.brand
        singleItemView.setItemQuality = individualData.quality
        
        navigationController?.pushViewController(singleItemView, animated: true)
    }
    
    func showPrice(_ price: Double) -> String {
        return "$\(price)"
    }
}
