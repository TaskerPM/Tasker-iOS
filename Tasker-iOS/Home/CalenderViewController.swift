//
//  CalenderViewController.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/08.
//

import UIKit
import FSCalendar

final class CalenderViewController: UIViewController {
    private let calenderView: FSCalendar = {
        let calender = FSCalendar()
        calender.locale = Locale(identifier: "ko_KR")
        calender.headerHeight = 44
        calender.scrollEnabled = false
        calender.appearance.titleWeekendColor = .setColor(.error)
        calender.appearance.headerMinimumDissolvedAlpha = .zero
        calender.appearance.headerDateFormat = "YYYY년 M월"
        calender.appearance.weekdayFont = .pretendardFont(size: 12, style: .regular)
        calender.appearance.headerTitleFont = .pretendardFont(size: 15, style: .bold)
        calender.appearance.titleFont = .pretendardFont(size: 12, style: .regular)
        
        return calender
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
        
        [calenderView, backwordButton, forwordButton].forEach(view.addSubview)
    }
    
    private func configureLayout() {
        calenderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(29)
        }
        
        backwordButton.snp.makeConstraints {
            $0.centerY.equalTo(calenderView.calendarHeaderView.collectionView)
            $0.centerX.equalToSuperview().offset(-view.frame.width * 0.4)
        }
        
        forwordButton.snp.makeConstraints {
            $0.centerY.equalTo(calenderView.calendarHeaderView.collectionView)
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
        calenderView.setCurrentPage(currentPage, animated: true)
    }
}
