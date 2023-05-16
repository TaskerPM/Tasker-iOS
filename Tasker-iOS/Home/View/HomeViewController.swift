//
//  HomeViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let yearMonthLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(size: 16, style: .bold)
        label.textColor = .setColor(.basicBlack)
        label.text = "2023년 5월"
        return label
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        let image = UIImage(named: "Home_calender")
        image?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCalendarCell.self, forCellWithReuseIdentifier: "HomeCalendarCell")
        collectionView.layer.borderWidth = 1
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureLayout()
        configureButtonAction()
        configureCollectionView()
    }
    
    private func configureUI() {
        [yearMonthLabel, calendarButton].forEach(calendarStackView.addArrangedSubview)
        [calendarStackView, calendarCollectionView].forEach(view.addSubview)
    }
    
    private func configureLayout() {
        calendarStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(12)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(73)
        }
    }
    
    private func configureCollectionView() {
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        calendarCollectionView.collectionViewLayout = createLayout()
    }
    
    private func configureButtonAction() {
        calendarButton.addAction(UIAction(handler: calendarButtonAction), for: .touchUpInside)
    }
    
    private func calendarButtonAction(_ action: UIAction) {
        let viewController = CalendarViewController()
        present(viewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCalendarCell", for: indexPath) as? HomeCalendarCell else { return UICollectionViewCell() }
        return cell
    }
    
    
}

extension HomeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            let item = CompositionalLayout.createItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1), spacing: 0)
            let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1), subitem: item, count: 7)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}
