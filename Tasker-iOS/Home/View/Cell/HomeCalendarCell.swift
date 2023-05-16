//
//  HomeCalendarCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/16.
//

import UIKit
import SnapKit

class HomeCalendarCell: UICollectionViewCell {
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(size: 12, style: .regular)
        label.textAlignment = .center
        label.text = "일"
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .mattoneFont(size: 12, style: .regular)
        label.textAlignment = .center
        label.text = "16"
        return label
    }()
    
    private let weekDayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureLayout()
        contentView.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [weekLabel, dayLabel].forEach(weekDayStackView.addArrangedSubview)
        contentView.addSubview(weekDayStackView)
    }
    
    private func configureLayout() {
        weekDayStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(11)
        }
    }
}
