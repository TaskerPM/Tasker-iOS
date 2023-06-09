//
//  ListTypeViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/08.
//

import UIKit
import SnapKit

class ListTypeViewController: UIViewController {
    var dummyDataSource = [0]
    
    private lazy var listTypeCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: createListCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLayout()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        listTypeCollectionView.delegate = self
        listTypeCollectionView.dataSource = self
        listTypeCollectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
        listTypeCollectionView.showsVerticalScrollIndicator = false
        listTypeCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureUI() {
        view.addSubview(listTypeCollectionView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        listTypeCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}

extension ListTypeViewController: UICollectionViewDelegate {
    
}

extension ListTypeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension ListTypeViewController {
    private func configureSwipeAction(_ indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { [weak self] action, view, conpletionHandler in
            guard let self else { return }
            
            let point = view.convert(view.bounds.origin, to: self.listTypeCollectionView)
            if let indexPath = self.listTypeCollectionView.indexPathForItem(at: point) {
                self.dummyDataSource.remove(at: indexPath.item)
                self.listTypeCollectionView.deleteItems(at: [indexPath])
            }
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
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = 3
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
