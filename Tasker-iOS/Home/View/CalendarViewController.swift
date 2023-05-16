//
//  CalendarViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/11.
//

import Foundation
import UIKit
import SnapKit

class CalendarViewController: UIViewController {
    private let yearWeekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(size: 15, style: .bold)
        label.textColor = .setColor(.basicBlack)
        return label
    }()
    
    private let todayButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘", for: .normal)
        button.setTitleColor(.setColor(.gray250), for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 12, style: .regular)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.setColor(.gray100).cgColor
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Home_calender_back"), for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Home_calender_forward"), for: .normal)
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeekCell.self, forCellWithReuseIdentifier: "WeekCell")
        collectionView.register(DaysCell.self, forCellWithReuseIdentifier: "DaysCell")
        return collectionView
    }()
    
    private let yearWeekTodayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private var calendarViewModel: CalendarViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        
        configureUI()
        configureLayout()
        configureSheetController()
        configureCollectionView()
        configureButtonAction()

        calendarViewModel = CalendarViewModel(baseDate: Date(), changedBaseDateHandler: { _ in
            self.collectionView.reloadData()
            self.yearWeekLabel.text = self.calendarViewModel?.localizedCalendarTitle
        })
        
        yearWeekLabel.text = calendarViewModel?.localizedCalendarTitle
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.isScrollEnabled = false
    }
    
    private func configureUI() {
        [yearWeekLabel, todayButton]
            .forEach(yearWeekTodayStackView.addArrangedSubview)
        [previousButton, yearWeekTodayStackView, nextButton, collectionView]
            .forEach(view.addSubview)
    }
    
    private func configureLayout() {
        previousButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(18)
        }
        
        yearWeekTodayStackView.snp.makeConstraints {
            $0.top.equalTo(previousButton.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(previousButton.snp.top)
            $0.trailing.equalToSuperview().inset(18)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(yearWeekTodayStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(9)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureSheetController() {
        guard let sheet = self.sheetPresentationController else { return }
        
        sheet.detents = [.medium()]
        sheet.selectedDetentIdentifier = .medium
        sheet.largestUndimmedDetentIdentifier = .large
        sheet.preferredCornerRadius = 22
    }
    
    private func configureButtonAction() {
        previousButton.addAction(UIAction(handler: didPreviousButtonTouched), for: .touchUpInside)
        todayButton.addAction(UIAction(handler: didTodayButtonTouched), for: .touchUpInside)
        nextButton.addAction(UIAction(handler: didNextButtonTouched), for: .touchUpInside)
    }
    
    private func didPreviousButtonTouched(_ action: UIAction) {
        calendarViewModel?.moveMonth(value: -1)
    }
    
    private func didNextButtonTouched(_ action: UIAction) {
        calendarViewModel?.moveMonth(value: 1)
    }
    
    private func didTodayButtonTouched(_ action: UIAction) {
        calendarViewModel?.today()
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let daysOfWeek = calendarViewModel?.dayOfTheWeek[indexPath.item] else { return }
            print(daysOfWeek)
        case 1:
            guard let day = calendarViewModel?.days[indexPath.item] else { return }
            calendarViewModel?.selectedDate = day.date
            collectionView.reloadData()
            print(day.number)
        default:
            return
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        case 1:
            return calendarViewModel?.days.count ?? 0
        default:
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let weekCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as? WeekCell else {
                return UICollectionViewCell()
            }
            guard let calendarViewModel else { break }
            weekCell.configureWeeks(calendarViewModel.dayOfTheWeek[indexPath.item])
            return weekCell
        case 1:
            guard let daysCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaysCell", for: indexPath) as? DaysCell else {
                return UICollectionViewCell()
            }
            guard let calendarViewModel else { break }
            daysCell.configureDays(calendarViewModel.days[indexPath.item])
            return daysCell
        default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
}

extension CalendarViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let weekItem = CompositionalLayout.createItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1), spacing: 6)
                let weekGroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.1), subitem: weekItem, count: self.calendarViewModel?.dayOfTheWeek.count ?? 7)
                let section = NSCollectionLayoutSection(group: weekGroup)
                return section
            case 1:
                let daysItem = CompositionalLayout.createItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1), spacing: 6)
                let horizontalDaysGroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.3), subitem: daysItem, count: 7)
                let verticalDaysGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalWidth(1), subitem: horizontalDaysGroup, count: 7)
                let section = NSCollectionLayoutSection(group: verticalDaysGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
                return section
            default:
                return nil
            }
        }
    }
}
