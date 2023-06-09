//
//  ListCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/10.
//

import UIKit
import SnapKit

class ListCell: UICollectionViewCell {
    private var isChecked = false {
        didSet {
            checkButton.setNeedsUpdateConfiguration()
        }
    }
    
    private lazy var checkButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let button = UIButton(type: .system)
        button.configuration = config
        button.isEnabled = false
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            let currentImage = self.isChecked ? UIImage(named: "Home_complete") : UIImage(named: "Home_incomplete")
            config?.image = currentImage
            button.configuration = config
        }
        
        button.addAction(UIAction(handler: { _ in
            self.isChecked.toggle()
            self.listTextField.attributedText = self.isChecked ? self.listTextField.text?.strikeThrough() : self.listTextField.text?.noneStrikeThrough()
        }), for: .touchUpInside)
        return button
    }()
    
    private let listTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "태스크를 입력해보세요."
        textField.font = .pretendardFont(size: 13, style: .regular)
        textField.textColor = .setColor(.basicBlack)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderColor = UIColor.setColor(.gray30).cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        
        listTextField.delegate = self
        listTextField.becomeFirstResponder()
        
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func textFieldDidEndEdtingGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldAction))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldAction(_ action: UIAction) {
        // TODO: 텍스트 입력이 완료된 셀을 탭하면 DetailViewController로 navigation 처리
        print("Tapped textFieldAction")
    }
    
    private func configureUI() {
        [checkButton, listTextField]
            .forEach(contentView.addSubview)
    }
    
    private func configureLayout() {
        checkButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(24)
        }

        listTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.leading.equalTo(checkButton.snp.trailing).offset(9)
        }
    }
}

extension ListCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true || textField.text == "" {
            textField.isEnabled = true
            checkButton.isEnabled = false
        } else {
            textField.isEnabled = false
            checkButton.isEnabled = true
            textFieldDidEndEdtingGesture()
        }
    }
}
