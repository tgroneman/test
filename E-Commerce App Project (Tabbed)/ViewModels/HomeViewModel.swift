//
//  HomeViewModel.swift
//  E-Commerce App Project (Tabbed)
//
//  ViewModel for HomeViewController
//

import Foundation

class HomeViewModel {
    
    let tvCategoryItems: Observable<[Item]> = Observable([])
    let laptopCategoryItems: Observable<[Item]> = Observable([])
    let desktopCategoryItems: Observable<[Item]> = Observable([])
    let mobileCategoryItems: Observable<[Item]> = Observable([])
    let tabletCategoryItems: Observable<[Item]> = Observable([])
    
    let sliderImages: Observable<[String]> = Observable([])
    let currentSliderIndex: Observable<Int> = Observable(0)
    
    init() {
        loadCategoryItems()
        loadSliderImages()
    }
    
    private func loadCategoryItems() {
        let categoryList = CategoryItemList.sharedInstance
        tvCategoryItems.value = categoryList.tvCategoryItemsList
        laptopCategoryItems.value = categoryList.laptopCategoryItemsList
        desktopCategoryItems.value = categoryList.desktopCategoryItemsList
        mobileCategoryItems.value = categoryList.mobileCategoryItemsList
        tabletCategoryItems.value = categoryList.tabletCategoryItemsList
    }
    
    private func loadSliderImages() {
        sliderImages.value = ["image1.jpg", "image2.png", "image4.jpg", "image5.jpg"]
    }
    
    func numberOfItems(for category: CategoryType) -> Int {
        switch category {
        case .tv:
            return tvCategoryItems.value.count
        case .laptop:
            return laptopCategoryItems.value.count
        case .desktop:
            return desktopCategoryItems.value.count
        case .mobile:
            return mobileCategoryItems.value.count
        case .tablet:
            return tabletCategoryItems.value.count
        }
    }
    
    func item(at index: Int, for category: CategoryType) -> Item {
        switch category {
        case .tv:
            return tvCategoryItems.value[index]
        case .laptop:
            return laptopCategoryItems.value[index]
        case .desktop:
            return desktopCategoryItems.value[index]
        case .mobile:
            return mobileCategoryItems.value[index]
        case .tablet:
            return tabletCategoryItems.value[index]
        }
    }
    
    func items(for category: CategoryType) -> [Item] {
        switch category {
        case .tv:
            return tvCategoryItems.value
        case .laptop:
            return laptopCategoryItems.value
        case .desktop:
            return desktopCategoryItems.value
        case .mobile:
            return mobileCategoryItems.value
        case .tablet:
            return tabletCategoryItems.value
        }
    }
    
    func categoryName(for category: CategoryType) -> String {
        switch category {
        case .tv:
            return "Television"
        case .laptop:
            return "Laptop"
        case .desktop:
            return "Desktop"
        case .mobile:
            return "Mobile"
        case .tablet:
            return "Tablet"
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        return "$\(price)"
    }
    
    func advanceSlider() {
        let imageCount = sliderImages.value.count
        if currentSliderIndex.value == imageCount - 1 {
            currentSliderIndex.value = 0
        } else {
            currentSliderIndex.value += 1
        }
    }
    
    func setSliderIndex(_ index: Int) {
        currentSliderIndex.value = index
    }
}

enum CategoryType {
    case tv
    case laptop
    case desktop
    case mobile
    case tablet
}
