//
//  CategoryItemsViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit

class CategoryItemsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - ViewModel
    private let viewModel = CategoryItemsViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    var receivedCategoryItemsList: [Item] = []
    var receivedCategoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        viewModel.configure(with: receivedCategoryItemsList, categoryName: receivedCategoryName ?? "")
        categoryName.text = viewModel.categoryName.value
        navigationItem.title = viewModel.categoryName.value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let individualData = viewModel.item(at: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath)
        
        if let itemImage = cell.viewWithTag(1001) as? UIImageView,
           let itemName = cell.viewWithTag(1002) as? UILabel,
           let itemPrice = cell.viewWithTag(1003) as? UILabel {
            if let url = URL(string: individualData.photoURL),
               let data = try? Data(contentsOf: url) {
                itemImage.image = UIImage(data: data)
            }
            itemName.text = individualData.itemName
            itemPrice.text = viewModel.formatPrice(individualData.price)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }
        
        let individualData = viewModel.item(at: indexPath.row)
        
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
}
