//
//  HomeViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, TAPageControlDelegate {
    
    private(set) var tvCategory: [Item] = []
    private(set) var laptopCategoryItemsList: [Item] = []
    private(set) var mobileCategoryItemsList: [Item] = []
    private(set) var desktopCategoryItemsList: [Item] = []
    private(set) var tabletCategoryItemsList: [Item] = []
    
    @IBOutlet var tvCollectionView: UICollectionView!
    @IBOutlet var laptopCollectionView: UICollectionView!
    @IBOutlet var desktopCollectionView: UICollectionView!
    @IBOutlet var mobileCollectionView: UICollectionView!
    @IBOutlet var tabletCollectionView: UICollectionView!
    
    @IBOutlet var sliderScrollView: UIScrollView!
    var sliderImagesData: [String] = []
    var sliderTimer: Timer?
    var sliderIndex: Int = 0
    var sliderCustomPageControl: TAPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderScrollView.delegate = self
        sliderImagesData = ["image1.jpg", "image2.png", "image4.jpg", "image5.jpg"]
        
        for i in 0..<sliderImagesData.count {
            let imageView = UIImageView(frame: CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: sliderScrollView.frame.height))
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: sliderImagesData[i])
            sliderScrollView.addSubview(imageView)
        }
        sliderIndex = 0
        
        sliderCustomPageControl = TAPageControl(frame: CGRect(x: 20, y: sliderScrollView.frame.origin.y + sliderScrollView.frame.size.height, width: sliderScrollView.frame.size.width, height: 40))
        sliderCustomPageControl.delegate = self
        sliderCustomPageControl.numberOfPages = sliderImagesData.count
        sliderCustomPageControl.dotSize = CGSize(width: 20, height: 20)
        sliderScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(sliderImagesData.count), height: sliderScrollView.frame.height)
        sliderScrollView.addSubview(sliderCustomPageControl)
        
        tvCollectionView.dataSource = self
        tvCollectionView.delegate = self
        
        laptopCollectionView.dataSource = self
        laptopCollectionView.delegate = self
        
        desktopCollectionView.dataSource = self
        desktopCollectionView.delegate = self
        
        mobileCollectionView.dataSource = self
        mobileCollectionView.delegate = self
        
        tabletCollectionView.dataSource = self
        tabletCollectionView.delegate = self
        
        tvCategory = CategoryItemList.sharedInstance.tvCategoryItemsList
        laptopCategoryItemsList = CategoryItemList.sharedInstance.laptopCategoryItemsList
        desktopCategoryItemsList = CategoryItemList.sharedInstance.desktopCategoryItemsList
        mobileCategoryItemsList = CategoryItemList.sharedInstance.mobileCategoryItemsList
        tabletCategoryItemsList = CategoryItemList.sharedInstance.tabletCategoryItemsList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var individualData: Item
        var cell: UICollectionViewCell
        
        if collectionView == tvCollectionView {
            individualData = tvCategory[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCellIdentifier", for: indexPath)
            
            if let itemImage = cell.viewWithTag(101) as? UIImageView,
               let itemName = cell.viewWithTag(102) as? UILabel,
               let itemPrice = cell.viewWithTag(103) as? UILabel {
                if let url = URL(string: individualData.photoURL),
                   let data = try? Data(contentsOf: url) {
                    itemImage.image = UIImage(data: data)
                }
                itemName.text = individualData.itemName
                itemPrice.text = showPrice(individualData.price)
            }
            return cell
        } else if collectionView == laptopCollectionView {
            individualData = laptopCategoryItemsList[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "laptopCellIdentifier", for: indexPath)
            
            if let itemImage = cell.viewWithTag(201) as? UIImageView,
               let itemName = cell.viewWithTag(202) as? UILabel,
               let itemPrice = cell.viewWithTag(203) as? UILabel {
                if let url = URL(string: individualData.photoURL),
                   let data = try? Data(contentsOf: url) {
                    itemImage.image = UIImage(data: data)
                }
                itemName.text = individualData.itemName
                itemPrice.text = showPrice(individualData.price)
            }
            return cell
        } else if collectionView == desktopCollectionView {
            individualData = desktopCategoryItemsList[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "desktopCellIdentifier", for: indexPath)
            
            if let itemImage = cell.viewWithTag(301) as? UIImageView,
               let itemName = cell.viewWithTag(302) as? UILabel,
               let itemPrice = cell.viewWithTag(303) as? UILabel {
                if let url = URL(string: individualData.photoURL),
                   let data = try? Data(contentsOf: url) {
                    itemImage.image = UIImage(data: data)
                }
                itemName.text = individualData.itemName
                itemPrice.text = showPrice(individualData.price)
            }
            return cell
        } else if collectionView == mobileCollectionView {
            individualData = mobileCategoryItemsList[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mobileCellIdentifiernow", for: indexPath)
            
            if let itemImage = cell.viewWithTag(401) as? UIImageView,
               let itemName = cell.viewWithTag(402) as? UILabel,
               let itemPrice = cell.viewWithTag(403) as? UILabel {
                if let url = URL(string: individualData.photoURL),
                   let data = try? Data(contentsOf: url) {
                    itemImage.image = UIImage(data: data)
                }
                itemName.text = individualData.itemName
                itemPrice.text = showPrice(individualData.price)
            }
            return cell
        } else {
            individualData = tabletCategoryItemsList[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabletCellIdentifier", for: indexPath)
            
            if let itemImage = cell.viewWithTag(501) as? UIImageView,
               let itemName = cell.viewWithTag(502) as? UILabel,
               let itemPrice = cell.viewWithTag(503) as? UILabel {
                if let url = URL(string: individualData.photoURL),
                   let data = try? Data(contentsOf: url) {
                    itemImage.image = UIImage(data: data)
                }
                itemName.text = individualData.itemName
                itemPrice.text = showPrice(individualData.price)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tvCollectionView {
            return tvCategory.count
        } else if collectionView == laptopCollectionView {
            return laptopCategoryItemsList.count
        } else if collectionView == desktopCollectionView {
            return desktopCategoryItemsList.count
        } else if collectionView == mobileCollectionView {
            return mobileCategoryItemsList.count
        } else {
            return tabletCategoryItemsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }
        
        var individualData: Item
        
        if collectionView == tvCollectionView {
            individualData = tvCategory[indexPath.row]
        } else if collectionView == laptopCollectionView {
            individualData = laptopCategoryItemsList[indexPath.row]
        } else if collectionView == desktopCollectionView {
            individualData = desktopCategoryItemsList[indexPath.row]
        } else if collectionView == mobileCollectionView {
            individualData = mobileCategoryItemsList[indexPath.row]
        } else {
            individualData = tabletCategoryItemsList[indexPath.row]
        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sliderTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runImages), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sliderTimer?.invalidate()
        sliderTimer = nil
    }
    
    @objc func runImages() {
        sliderCustomPageControl.currentPage = sliderIndex
        if sliderIndex == sliderImagesData.count - 1 {
            sliderIndex = 0
        } else {
            sliderIndex += 1
        }
        taPageControl(sliderCustomPageControl, didSelectPageAt: sliderIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        sliderCustomPageControl.currentPage = pageIndex
        sliderIndex = pageIndex
    }
    
    func taPageControl(_ pageControl: TAPageControl!, didSelectPageAt currentIndex: Int) {
        sliderIndex = currentIndex
        sliderScrollView.scrollRectToVisible(CGRect(x: view.frame.width * CGFloat(currentIndex), y: 0, width: view.frame.width, height: sliderScrollView.frame.height), animated: true)
    }
    
    @IBAction func televisionCategoryButton(_ sender: UIButton) {
        guard let categoryItemsView = storyboard?.instantiateViewController(withIdentifier: "categoryItemViewStoryBoardIdentifier") as? CategoryItemsViewController else { return }
        categoryItemsView.receivedCategoryItemsList = tvCategory
        categoryItemsView.receivedCategoryName = "Television"
        navigationController?.pushViewController(categoryItemsView, animated: true)
    }
    
    @IBAction func laptopCategoryButton(_ sender: UIButton) {
        guard let categoryItemsView = storyboard?.instantiateViewController(withIdentifier: "categoryItemViewStoryBoardIdentifier") as? CategoryItemsViewController else { return }
        categoryItemsView.receivedCategoryItemsList = laptopCategoryItemsList
        categoryItemsView.receivedCategoryName = "Laptop"
        navigationController?.pushViewController(categoryItemsView, animated: true)
    }
    
    @IBAction func desktopCategoryButton(_ sender: UIButton) {
        guard let categoryItemsView = storyboard?.instantiateViewController(withIdentifier: "categoryItemViewStoryBoardIdentifier") as? CategoryItemsViewController else { return }
        categoryItemsView.receivedCategoryItemsList = desktopCategoryItemsList
        categoryItemsView.receivedCategoryName = "Desktop"
        navigationController?.pushViewController(categoryItemsView, animated: true)
    }
    
    @IBAction func mobileCategoryButton(_ sender: UIButton) {
        guard let categoryItemsView = storyboard?.instantiateViewController(withIdentifier: "categoryItemViewStoryBoardIdentifier") as? CategoryItemsViewController else { return }
        categoryItemsView.receivedCategoryItemsList = mobileCategoryItemsList
        categoryItemsView.receivedCategoryName = "Mobile"
        navigationController?.pushViewController(categoryItemsView, animated: true)
    }
    
    @IBAction func tabletCategoryButton(_ sender: UIButton) {
        guard let categoryItemsView = storyboard?.instantiateViewController(withIdentifier: "categoryItemViewStoryBoardIdentifier") as? CategoryItemsViewController else { return }
        categoryItemsView.receivedCategoryItemsList = tabletCategoryItemsList
        categoryItemsView.receivedCategoryName = "Tablet"
        navigationController?.pushViewController(categoryItemsView, animated: true)
    }
}
