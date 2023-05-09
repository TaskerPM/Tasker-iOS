//
//  HomeCalendarCell.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/09.
//

import UIKit
import FSCalendar

final class HomeCalendarCell: FSCalendarCell {
    private var isSelectedDate: Bool?
    private var date: Date?
    
    private let dayformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    private let weekformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "E"
        return formatter
    }()
    
    private let selectedView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .setColor(.basicBlack)
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(size: 12, style: .regular)
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .mattoneFont(size: 12, style: .regular)
        return label
    }()
    
    private let dayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init!(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 41, height: 61))
        
        [weekdayLabel, dayLabel].forEach(dayStackView.addArrangedSubview)
        [selectedView, dayStackView].enumerated().forEach {
            contentView.insertSubview($1, at: $0)
        }
        
        selectedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dayStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        
        guard let isSelectedDate else { return }
        
        selectedView.isHidden = !isSelectedDate
        if isSelectedDate {
            weekdayLabel.textColor = .setColor(.white)
            dayLabel.textColor = .setColor(.white)
        }
        // 기본설정하기
    }
    
    func setData(isSelectedDate: Bool, date: Date) {
        self.isSelectedDate = isSelectedDate
        self.date = date
        weekdayLabel.text = "\(weekformatter.string(from: date))"
        dayLabel.text = "\(dayformatter.string(from: date))"
    }
}
