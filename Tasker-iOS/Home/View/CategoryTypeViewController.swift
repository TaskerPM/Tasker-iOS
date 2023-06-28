//
//  CategoryTypeViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/08.
//

import UIKit
import SnapKit

class CategoryTypeViewController: UIViewController {
    private lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createListCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureUI()
        configureLayout()
    }
    
    private func configureCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryTypeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryTypeHeaderView")
        categoryCollectionView.register(CategoryTypeTaskCell.self, forCellWithReuseIdentifier: "CategoryTypeTaskCell")
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureUI() {
        view.addSubview(categoryCollectionView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}

extension CategoryTypeViewController: UICollectionViewDelegate {
    
}

extension CategoryTypeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryTypeHeaderView", for: indexPath) as? CategoryTypeHeaderView else { return UICollectionReusableView() }
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryTypeTaskCell", for: indexPath) as? CategoryTypeTaskCell else { return UICollectionViewCell() }
        return cell
    }
}

extension CategoryTypeViewController {
    private func configureSwipeAction(_ indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { [weak self] action, view, conpletionHandler in
            guard let self else { return }
            
            let point = view.convert(view.bounds.origin, to: self.categoryCollectionView)
//            if let indexPath = self.categoryCollectionView.indexPathForItem(at: point) {
//                self.viewModel.deleteItem(at: indexPath.item)
//                self.categoryCollectionView.reloadData()
//            }
            
            conpletionHandler(true)
        }
        deleteAction.backgroundColor = .setColor(.basicRed)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func createListCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            config.trailingSwipeActionsConfigurationProvider = self.configureSwipeAction(_:)
            config.headerMode = .supplementary
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = 3
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

extension CategoryTypeViewController: AddNewCellDelegate {
    func tappedAddCellButton() {
        print("카테고리 타입 뷰 셀 추가해줘잉")
    }
    
    
}
