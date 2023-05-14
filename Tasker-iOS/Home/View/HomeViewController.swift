//
//  HomeViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import UIKit
import FSCalendar

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
    
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scope = .week
        calendar.weekdayHeight = 0
        calendar.headerHeight = 0
        calendar.appearance.titleFont = .pretendardFont(size: 12, style: .regular)
        calendar.register(HomeCalendarCell.self, forCellReuseIdentifier: "HomeCalendarCell")
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        configureUI()
        configureLayout()
        configureButtonAction()
    }
    
    private func configureUI() {
        [yearMonthLabel, calendarButton].forEach(calendarStackView.addArrangedSubview)
        
        view.addSubview(calendarStackView)
        view.addSubview(calendarView)
    }
    
    private func configureLayout() {
        calendarStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(12)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(calendarStackView.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400)
        }
    }
    
    private func configureButtonAction() {
        calendarButton.addAction(UIAction(handler: calendarButtonAction), for: .touchUpInside)
    }
    
    private func calendarButtonAction(_ action: UIAction) {
        let viewController = NSCalendarViewController()
        present(viewController, animated: true)
    }
}

extension HomeViewController: FSCalendarDelegate {
    
}

extension HomeViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: "HomeCalendarCell", for: date, at: position) as? HomeCalendarCell else { return FSCalendarCell() }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        let isSelected = dateFormatter.string(from: date) == dateFormatter.string(from: Date())
        
        cell.setData(isSelectedDate: isSelected, date: date)
        return cell
    }
}
