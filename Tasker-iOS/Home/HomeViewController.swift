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
    
    private let calenderButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
        let image = UIImage(systemName: "calendar")
        image?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let calenderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLayout()
        configureButtonAction()
    }
    
    private func configureUI() {
        [yearMonthLabel, calenderButton].forEach(calenderStackView.addArrangedSubview)
        
        view.addSubview(calenderStackView)
    }
    
    private func configureLayout() {
        calenderStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(12)
        }
    }
    
    private func configureButtonAction() {
        calenderButton.addAction(UIAction(handler: calenderButtonAction), for: .touchUpInside)
    }
    
    private func calenderButtonAction(_ action: UIAction) {
        let viewController = CalenderViewController()
        
        present(viewController, animated: true)
    }
}
