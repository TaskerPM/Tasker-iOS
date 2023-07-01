//
//  ListTypeViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/08.
//

import UIKit
import SnapKit

class ListTypeViewController: UIViewController {
    private var viewModel = TaskViewModel()
    
    private lazy var listTypeCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: createListCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLayout()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTypeCollectionView.reloadData()
    }
    
    private func configureCollectionView() {
        listTypeCollectionView.delegate = self
        listTypeCollectionView.dataSource = self
        listTypeCollectionView.register(ListTypeTaskCell.self, forCellWithReuseIdentifier: "ListTypeTaskCell")
        listTypeCollectionView.register(TaskAddButtonCell.self, forCellWithReuseIdentifier: "TaskAddButtonCell")
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let newTask = TaskListModel(title: "", startTime: "", endTime: "", category: Category(categoryName: "", categoryColor: CategoryColor(backgroundColor: "", textColor: "")), isCompleted: false)
            viewModel.addItem(newTask)
            collectionView.reloadData()
        }
    }
}

extension ListTypeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.itemCount
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListTypeTaskCell", for: indexPath) as? ListTypeTaskCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.configure(viewModel, indexPath: indexPath)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskAddButtonCell", for: indexPath) as? TaskAddButtonCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ListTypeViewController: TappedCellDelegate {
    func tappedListCell() {
        guard let homeVC = self.parent as? HomeViewController else { return }
        let detailVC = DetailViewController()
        
        homeVC.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListTypeViewController {
    private func configureSwipeAction(_ indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { [weak self] action, view, conpletionHandler in
            guard let self else { return }
            
            let point = view.convert(view.bounds.origin, to: self.listTypeCollectionView)
            if let indexPath = self.listTypeCollectionView.indexPathForItem(at: point) {
                self.viewModel.deleteItem(at: indexPath.item)
                self.listTypeCollectionView.reloadData()
            }
            
            conpletionHandler(true)
        }
        deleteAction.backgroundColor = .setColor(.basicRed)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func createListCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                config.trailingSwipeActionsConfigurationProvider = self.configureSwipeAction(_:)
                
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
                section.interGroupSpacing = 3
                return section
            case 1:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
                section.contentInsets = .init(top: 11, leading: 0, bottom: 0, trailing: 0)
                return section
            default:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
                return section
            }
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
