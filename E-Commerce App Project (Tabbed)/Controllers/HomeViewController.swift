//
//  HomeViewController.swift
//  E-Commerce App Project (Tabbed)
//
//  Converted to Swift with MVVM pattern
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, TAPageControlDelegate {
    
    // MARK: - ViewModel
    private let viewModel = HomeViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet var tvCollectionView: UICollectionView!
    @IBOutlet var laptopCollectionView: UICollectionView!
    @IBOutlet var desktopCollectionView: UICollectionView!
    @IBOutlet var mobileCollectionView: UICollectionView!
    @IBOutlet var tabletCollectionView: UICollectionView!
    
    @IBOutlet var sliderScrollView: UIScrollView!
    var sliderTimer: Timer?
    var sliderCustomPageControl: TAPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        setupCollectionViews()
        bindViewModel()
    }
    
    private func setupSlider() {
        sliderScrollView.delegate = self
        let sliderImages = viewModel.sliderImages.value
        
        for i in 0..<sliderImages.count {
            let imageView = UIImageView(frame: CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: sliderScrollView.frame.height))
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: sliderImages[i])
            sliderScrollView.addSubview(imageView)
        }
        
        sliderCustomPageControl = TAPageControl(frame: CGRect(x: 20, y: sliderScrollView.frame.origin.y + sliderScrollView.frame.size.height, width: sliderScrollView.frame.size.width, height: 40))
        sliderCustomPageControl.delegate = self
        sliderCustomPageControl.numberOfPages = sliderImages.count
        sliderCustomPageControl.dotSize = CGSize(width: 20, height: 20)
        sliderScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(sliderImages.count), height: sliderScrollView.frame.height)
        sliderScrollView.addSubview(sliderCustomPageControl)
    }
    
    private func setupCollectionViews() {
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
    }
    
    private func bindViewModel() {
        viewModel.currentSliderIndex.bind { [weak self] index in
            guard let self = self else { return }
            self.sliderCustomPageControl.currentPage = index
            self.sliderScrollView.scrollRectToVisible(CGRect(x: self.view.frame.width * CGFloat(index), y: 0, width: self.view.frame.width, height: self.sliderScrollView.frame.height), animated: true)
        }
    }
    
    private func categoryType(for collectionView: UICollectionView) -> CategoryType {
        if collectionView == tvCollectionView { return .tv }
        if collectionView == laptopCollectionView { return .laptop }
        if collectionView == desktopCollectionView { return .desktop }
        if collectionView == mobileCollectionView { return .mobile }
        return .tablet
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categoryType(for: collectionView)
        let individualData = viewModel.item(at: indexPath.row, for: category)
        
        let cellIdentifier: String
        let tagOffset: Int
        
        switch category {
        case .tv:
            cellIdentifier = "tvCellIdentifier"
            tagOffset = 100
        case .laptop:
            cellIdentifier = "laptopCellIdentifier"
            tagOffset = 200
        case .desktop:
            cellIdentifier = "desktopCellIdentifier"
            tagOffset = 300
        case .mobile:
            cellIdentifier = "mobileCellIdentifiernow"
            tagOffset = 400
        case .tablet:
            cellIdentifier = "tabletCellIdentifier"
            tagOffset = 500
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let itemImage = cell.viewWithTag(tagOffset + 1) as? UIImageView,
           let itemName = cell.viewWithTag(tagOffset + 2) as? UILabel,
           let itemPrice = cell.viewWithTag(tagOffset + 3) as? UILabel {
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
        return viewModel.numberOfItems(for: categoryType(for: collectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }
        
        let category = categoryType(for: collectionView)
        let individualData = viewModel.item(at: indexPath.row, for: category)
        
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
        viewModel.advanceSlider()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        viewModel.setSliderIndex(pageIndex)
    }
    
    func taPageControl(_ pageControl: TAPageControl!, didSelectPageAt currentIndex: Int) {
        viewModel.setSliderIndex(currentIndex)
    }
    
    @IBAction func televisionCategoryButton(_ sender: UIButton) {
        navigateToCategory(.tv)
    }
    
    @IBAction func laptopCategoryButton(_ sender: UIButton) {
        navigateToCategory(.laptop)
    }
    
    @IBAction func desktopCategoryButton(_ sender: UIButton) {
        navigateToCategory(.desktop)
    }
    
    @IBAction func mobileCategoryButton(_ sender: UIButton) {
        navigateToCategory(.mobile)
    }
    
    @IBAction func tabletCategoryButton(_ sender: UIButton) {
        navigateToCategory(.tablet)
    }
    
    private func navigateToCategory(_ category: CategoryType) {
        guard let categoryItemsView = storyboard?.instantiateViewController(withIdentifier: "categoryItemViewStoryBoardIdentifier") as? CategoryItemsViewController else { return }
        categoryItemsView.receivedCategoryItemsList = viewModel.items(for: category)
        categoryItemsView.receivedCategoryName = viewModel.categoryName(for: category)
        navigationController?.pushViewController(categoryItemsView, animated: true)
    }
}
