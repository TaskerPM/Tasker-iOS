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
    
    private lazy var calendarCollectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                                 collectionViewLayout: createWeekCalendarCollectionViewLayout())
    
    private lazy var listTypeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton(type: .system)
        button.configuration = config
        button.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            
            var config = button.configuration
            let currentImage = self.isSelectedListTypeViewButton ? UIImage(named: "Home_list(select)") : UIImage(named: "Home_list(unselect)")
            config?.image = currentImage
            button.configuration = config
        }
        
        button.addAction(UIAction(handler: { _ in
            if self.children != [self.listTypeVC] {
                self.remove(self.categoryTypeVC)
                self.add(self.listTypeVC)
                self.configureListTypeViewLayout()
                guard self.isSelectedListTypeViewButton == false else { return }
                self.isSelectedListTypeViewButton.toggle()
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryTypeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton(type: .system)
        button.configuration = config
        button.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            
            var config = button.configuration
            let currentImage = self.isSelectedListTypeViewButton ? UIImage(named: "Home_category(unselect)") : UIImage(named: "Home_category(select)")
            config?.image = currentImage
            button.configuration = config
        }
        
        button.addAction(UIAction(handler: { _ in
            if self.children != [self.categoryTypeVC] {
                self.remove(self.listTypeVC)
                self.add(self.categoryTypeVC)
                self.configureCategoryTypeViewLayout()
                self.isSelectedListTypeViewButton.toggle()
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private let typeSelectButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private var isSelectedListTypeViewButton = true {
        didSet {
            listTypeButton.setNeedsUpdateConfiguration()
            categoryTypeButton.setNeedsUpdateConfiguration()
        }
    }

    private var calendarViewModel: CalendarViewModel?
    
    private let listTypeVC = ListTypeViewController()
    private let categoryTypeVC = CategoryTypeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureLayout()
        configureButtonAction()
        configureCollectionView()
        
        calendarViewModel = CalendarViewModel()
        calendarViewModel?.configureChangedBaseDateForWeekCompletion { [weak self] in
            self?.yearMonthLabel.text = self?.calendarViewModel?.localizedCalendarTitle
            self?.calendarCollectionView.reloadData()
        }
        
        yearMonthLabel.text = calendarViewModel?.localizedCalendarTitle
    }
    
    private func configureUI() {
        [yearMonthLabel, calendarButton]
            .forEach(calendarStackView.addArrangedSubview)
        
        [listTypeButton, categoryTypeButton]
            .forEach(typeSelectButtonStackView.addArrangedSubview)
        
        [calendarStackView, calendarCollectionView, typeSelectButtonStackView, listTypeVC.view]
            .forEach(view.addSubview)
    }
    
    private func configureLayout() {
        calendarStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(12)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(61)
        }
        
        typeSelectButtonStackView.snp.makeConstraints {
            $0.top.equalTo(calendarCollectionView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(14)
        }
        
        configureListTypeViewLayout()
    }
    
    private func configureListTypeViewLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        listTypeVC.view.snp.makeConstraints {
            $0.top.equalTo(typeSelectButtonStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeArea.snp.bottom)
        }
    }
    
    private func configureCategoryTypeViewLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        categoryTypeVC.view.snp.makeConstraints {
            $0.top.equalTo(typeSelectButtonStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeArea.snp.bottom)
        }
    }
    
    private func configureCollectionView() {
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        calendarCollectionView.register(HomeCalendarCell.self, forCellWithReuseIdentifier: "HomeCalendarCell")
        calendarCollectionView.isScrollEnabled = false
    }
    
    private func configureButtonAction() {
        calendarButton.addAction(UIAction(handler: calendarButtonAction), for: .touchUpInside)
    }
    
    private func calendarButtonAction(_ action: UIAction) {
        let calendarVC = CalendarViewController(calendarViewModel: calendarViewModel)
        calendarVC.modalPresentationStyle = .custom
        calendarVC.transitioningDelegate = self
        present(calendarVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 아이템을 선택하면 배경색 및 텍스트컬러가 변경되고 해당 일자의 데이터 가져오기
        guard let day = calendarViewModel?.daysForWeek[indexPath.item] else { return }
        
        calendarViewModel?.action(.selectDate(day.date))
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCalendarCell", for: indexPath) as? HomeCalendarCell,
            let calendarViewModel = calendarViewModel
        else {
            return UICollectionViewCell()
        }
        
        let day = calendarViewModel.daysForWeek[indexPath.item]
        let week = calendarViewModel.dayOfTheWeek[indexPath.item]
        
        cell.configureCell(week: week, day: day.number, isSelected: day.isSelected)
        return cell
    }
}

extension HomeViewController {
    private func createWeekCalendarCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            let item = CompositionalLayout.createItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1), spacing: 0)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1), subitem: item, count: 7)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalViewPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}
