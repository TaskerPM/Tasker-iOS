//
//  TimePickerViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/27.
//

import UIKit
import SnapKit

class TimePickerViewController: UIViewController {
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "시작 시간"
        label.textColor = .setColor(.gray250)
        label.font = .pretendardFont(size: 15, style: .medium)
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "다음"
        config.attributedTitle?.font = .pretendardFont(size: 13, style: .medium)
        config.baseForegroundColor = .setColor(.basicBlack)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Tapped nextButton")
        }))
    }()
    
    private let topLabelButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    private let seperateLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.setColor(.gray30).cgColor
        return view
    }()
    
    private let startTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.timeZone = .autoupdatingCurrent
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 5
        timePicker.setContentHuggingPriority(.defaultLow, for: .vertical)
        return timePicker
    }()
    
    private let endTimePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.timeZone = .autoupdatingCurrent
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 5
        timePicker.setContentHuggingPriority(.defaultLow, for: .vertical)
        return timePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        view.tag = 1
        
        configureUI()
        configureLayout()
    }
    
    override func viewWillLayoutSubviews() {
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    private func configureUI() {
        [startTimeLabel, nextButton]
            .forEach(topLabelButtonStackView.addArrangedSubview)
        
        [topLabelButtonStackView, seperateLineView, startTimePicker]
            .forEach(view.addSubview)
    }
    
    private func configureLayout() {
        topLabelButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        seperateLineView.snp.makeConstraints {
            $0.top.equalTo(topLabelButtonStackView.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        startTimePicker.snp.makeConstraints {
            $0.top.equalTo(seperateLineView.snp.top).offset(7)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
