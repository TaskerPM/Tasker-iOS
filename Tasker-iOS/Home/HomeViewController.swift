//
//  HomeViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLayout()
        configureButtonAction()
    }
    
    private func configureUI() {
        [yearMonthLabel, calendarButton].forEach(calendarStackView.addArrangedSubview)
        
        view.addSubview(calendarStackView)
    }
    
    private func configureLayout() {
        calendarStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(12)
        }
    }
    
    private func configureButtonAction() {
        calendarButton.addAction(UIAction(handler: calendarButtonAction), for: .touchUpInside)
    }
    
    private func calendarButtonAction(_ action: UIAction) {
        let viewController = CalendarViewController()
        
        present(viewController, animated: true)
    }
}
