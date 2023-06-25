//
//  CalendarViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/11.
//

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
    
    private let calendarViewModel: CalendarViewModel?
    
    init(calendarViewModel: CalendarViewModel?) {
        self.calendarViewModel = calendarViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        view.tag = 0
        
        configureUI()
        configureLayout()
        configureCollectionView()
        configureButtonAction()
        
        calendarViewModel?.configureChangedBaseDateForMonthCompletion { [weak self] in
            self?.yearWeekLabel.text = self?.calendarViewModel?.localizedCalendarTitle
            self?.collectionView.reloadData()
        }
        
        yearWeekLabel.text = calendarViewModel?.localizedCalendarTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarViewModel?.action(.pushCalendarView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        calendarViewModel?.action(.popCalendarView)
    }
    
    override func viewWillLayoutSubviews() {
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
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

    private func configureButtonAction() {
        previousButton.addAction(UIAction(handler: didPreviousButtonTouched), for: .touchUpInside)
        todayButton.addAction(UIAction(handler: didTodayButtonTouched), for: .touchUpInside)
        nextButton.addAction(UIAction(handler: didNextButtonTouched), for: .touchUpInside)
    }
    
    private func didPreviousButtonTouched(_ action: UIAction) {
        calendarViewModel?.action(.moveMonth(value: -1))
        collectionView.reloadData()
    }
    
    private func didNextButtonTouched(_ action: UIAction) {
        calendarViewModel?.action(.moveMonth(value: 1))
        collectionView.reloadData()
    }
    
    private func didTodayButtonTouched(_ action: UIAction) {
        calendarViewModel?.action(.today)
        collectionView.reloadData()
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let day = calendarViewModel?.days[indexPath.item] else { return }
            
            calendarViewModel?.action(.selectDate(day.date))
            collectionView.reloadData()
            dismiss(animated: true)
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
                return section
            default:
                return nil
            }
        }
    }
}
