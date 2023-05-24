//
//  CategoryListViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/23.
//

import UIKit
import SnapKit

class CategoryListViewController: UIViewController {
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        
        configureNavigationBar()
        configureCollectionView()
        configureUI()
        configureLayout()
    }
    
    private func configureNavigationBar() {
        let navigationBack = UIImage(named: "navigation_back")
        let topTitle = UILabel()
        topTitle.font = .pretendardFont(size: 16, style: .regular)
        topTitle.text = "카테고리"
        topTitle.textColor = .setColor(.gray900)
        let plusImage = UIImage(named: "Home_add_task")
        
        let backBarButton = UIBarButtonItem(image: navigationBack, style: .plain, target: self, action: #selector(popToVC))
        let plusBarButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addCategory))
        
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = .setColor(.gray900)
        self.navigationItem.titleView = topTitle
        self.navigationItem.rightBarButtonItem = plusBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = .setColor(.gray900)
    }
    
    @objc func popToVC() {
//        self.navigationController?.popViewController(animated: true)
        print("Tapped popToVC")
    }
    
    @objc func addCategory() {
        print("Tapped addCategory")
        let createCategoryVC = ConfigureCategoryViewController()
        createCategoryVC.topTitleLabel.text = "카테고리 생성"
        self.navigationController?.pushViewController(createCategoryVC, animated: true)
    }
    
    private func configureCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.collectionViewLayout = createLayout()
        categoryCollectionView.register(CategoryListCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoryCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func configureUI() {
        view.addSubview(categoryCollectionView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview().inset(11)
        }
    }
    
    private func configureActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.setBackgroundColor(color: .setColor(.white))
        actionSheet.setTint(color: .setColor(.gray900))

        let selectCategoryAction = UIAlertAction(title: "카테고리 선택", style: .default) { _ in
            print("Tapped selectCategoryAction")
        }
        
        let editCategoryAction = UIAlertAction(title: "카테고리 수정", style: .default) { [weak self] _ in
            print("Tapped editCategoryAction")
            guard let self else { return }
            let createCategoryVC = ConfigureCategoryViewController()
            createCategoryVC.topTitleLabel.text = "카테고리 수정"
            self.navigationController?.pushViewController(createCategoryVC, animated: true)
        }
        
        let deleteCategoryAction = UIAlertAction(title: "카테고리 삭제", style: .destructive) { _ in
            print("Tapped deleteCategoryAction")
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [selectCategoryAction, editCategoryAction, deleteCategoryAction, cancelAction]
            .forEach(actionSheet.addAction)
        
        self.present(actionSheet, animated: true)
    }
}

extension CategoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        configureActionSheet()
    }
}

extension CategoryListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryListCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension CategoryListViewController {
    func createLayout() -> UICollectionViewLayout {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.25), height: .fractionalWidth(0.1), spacing: 0)
        item.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        let horizontalGroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.1), subitems: [item])
        let verticalGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalWidth(1), subitems: [horizontalGroup])
        verticalGroup.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: verticalGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension UIAlertController {

    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }

    //Set title font and title color
    func setTitle(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }

        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }

    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }

        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }

    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
