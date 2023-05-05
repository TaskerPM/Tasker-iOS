//
//  OnboardingViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .setColor(.gray150)
        pageControl.currentPageIndicatorTintColor = .setColor(.basicBlack)
        pageControl.numberOfPages = OnboardingModel.imageArray.count
        return pageControl
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.setColor(.white), for: .normal)
        button.backgroundColor = .setColor(.basicBlack)
        button.titleLabel?.font = .pretendardFont(size: 17, style: .semiBold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let onboardingModel: [OnboardingModel] = OnboardingModel.imageArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        
        setCollectionView()
        configureUI()
        configureButtonAction()
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
    }
    
    private func configureUI() {
        [collectionView, pageControl, startButton]
            .forEach(view.addSubview)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(469)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(49)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(70)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
    
    private func configureButtonAction() {
        startButton.addAction(UIAction(handler: tappedStartButton), for: .touchUpInside)
    }
    
    private func tappedStartButton(_ action: UIAction) {
        let loginVC = LoginViewController(viewModel: LoginViewModel())
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        cell.configure(onboardingModel[indexPath.item])
        return cell
    }
}

extension OnboardingViewController {
    func createLayout() -> UICollectionViewLayout {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { (item, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            self.pageControl.currentPage = index
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


