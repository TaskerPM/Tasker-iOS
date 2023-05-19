//
//  CalendarCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/12.
//

import UIKit
import SnapKit

class WeekCell: UICollectionViewCell {
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(size: 13, style: .regular)
        label.textColor = .setColor(.gray400)
        label.contentMode = .center
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWeeks(_ week: String) {
        weekLabel.text = week
    }

    private func configureUI() {
        contentView.addSubview(weekLabel)
    }
    
    private func configureLayout() {
        weekLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

class DaysCell: UICollectionViewCell {
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(size: 13, style: .regular)
        label.textColor = .setColor(.basicBlack)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .setColor(.white)
        contentView.layer.cornerRadius = contentView.frame.width / 2
        
        configureUI()
        configureLayout()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDays(_ day: Day) {
        dayLabel.text = "\(day.number)"
        
        if day.isSelected {
            dayLabel.textColor = .setColor(.white)
        } else if day.isWithinDisplayedMonth {
            dayLabel.textColor = .setColor(.basicBlack)
        } else {
            dayLabel.textColor = .setColor(.gray300)
        }
        
        contentView.backgroundColor = day.isSelected ? .setColor(.basicBlack) : .setColor(.white)
    }

    private func configureUI() {
        contentView.addSubview(dayLabel)
    }
    
    private func configureLayout() {
        dayLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
