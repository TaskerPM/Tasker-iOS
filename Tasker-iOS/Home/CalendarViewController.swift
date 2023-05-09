//
//  CalendarViewController.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/08.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.headerHeight = 44
        calendar.scrollEnabled = false
        calendar.appearance.titleWeekendColor = .setColor(.error)
        calendar.appearance.headerMinimumDissolvedAlpha = .zero
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.weekdayFont = .pretendardFont(size: 12, style: .regular)
        calendar.appearance.headerTitleFont = .pretendardFont(size: 15, style: .bold)
        calendar.appearance.titleFont = .pretendardFont(size: 12, style: .regular)
        
        return calendar
    }()
    
    private let backwordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Home_calender_back"), for: .normal)
        return button
    }()
    
    private let forwordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Home_calender_forward"), for: .normal)
        return button
    }()
    
    private var currentPage: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        
        configureSheetController()
        configureUI()
        configureLayout()
        configureButtonAction()
    }
    
    private func configureSheetController() {
        guard let sheet = self.sheetPresentationController else { return }
        
        sheet.detents = [.medium()]
        sheet.selectedDetentIdentifier = .medium
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [calendarView, backwordButton, forwordButton].forEach(view.addSubview)
    }
    
    private func configureLayout() {
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(29)
        }
        
        backwordButton.snp.makeConstraints {
            $0.centerY.equalTo(calendarView.calendarHeaderView.collectionView)
            $0.centerX.equalToSuperview().offset(-view.frame.width * 0.4)
        }
        
        forwordButton.snp.makeConstraints {
            $0.centerY.equalTo(calendarView.calendarHeaderView.collectionView)
            $0.centerX.equalToSuperview().offset(view.frame.width * 0.4)
        }
    }
    
    private func configureButtonAction() {
        forwordButton.addAction(UIAction(handler: moveToForwordMonth), for: .touchUpInside)
        backwordButton.addAction(UIAction(handler: moveToBackwordMonth), for: .touchUpInside)
    }
    
    private func moveToForwordMonth(_ action: UIAction) {
        moveCurrentPage(isForword: true)
    }
    
    private func moveToBackwordMonth(_ action: UIAction) {
        moveCurrentPage(isForword: false)
    }
    
    private func moveCurrentPage(isForword: Bool) {
        let today = Date()
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isForword ? 1 : -1
        
        guard let currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? today) else { return }
        self.currentPage = currentPage
        calendarView.setCurrentPage(currentPage, animated: false)
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: false)
        }
    }
}
