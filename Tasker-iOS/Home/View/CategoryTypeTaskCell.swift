//
//  CategoryTypeTaskCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/29.
//

import UIKit
import SnapKit

class CategoryTypeTaskCell: UICollectionViewCell {
    private var viewModel: TaskViewModel?
    private var indexPath: IndexPath?
    
    weak var delegate: TappedCellDelegate?
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.addAction(UIAction(handler: buttonCheckedAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "태스크를 입력해보세요."
        textField.font = .pretendardFont(size: 13, style: .regular)
        textField.textColor = .setColor(.basicBlack)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        taskTextField.delegate = self
        taskTextField.becomeFirstResponder()
        
        configureContenView()
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContenView() {
        contentView.layer.borderColor = UIColor.setColor(.gray30).cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
    }
    
    private func buttonCheckedAction(_ action: UIAction) {
        guard let viewModel = self.viewModel, let indexPath = self.indexPath else { return }
        
        viewModel.toggleItemCompletion(at: indexPath.item)
        let isCompleted = viewModel.item(at: indexPath.item).isCompleted
        if isCompleted {
            checkButton.setImage(UIImage(named: "Home_complete"), for: .normal)
            self.taskTextField.attributedText = self.taskTextField.text?.strikeThrough()
        } else {
            checkButton.setImage(UIImage(named: "Home_incomplete"), for: .normal)
            self.taskTextField.attributedText = self.taskTextField.text?.noneStrikeThrough()
        }
    }
    
    private func textFieldDidEndEdtingGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editTaskAction))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func editTaskAction(_ action: UIAction) {
        delegate?.tappedListCell()
    }
    
    func configure(_ viewModel: TaskViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        
        let item = viewModel.item(at: indexPath.item)
        
        taskTextField.text = item.title
        taskTextField.attributedText = item.isCompleted ? taskTextField.text?.strikeThrough() : taskTextField.text?.noneStrikeThrough()
        
        let image = item.isCompleted ? UIImage(named: "Home_complete") : UIImage(named: "Home_incomplete")
        checkButton.setImage(image, for: .normal)
    }
    
    private func configureUI() {
        [checkButton, taskTextField]
            .forEach(contentView.addSubview)
    }
    
    private func configureLayout() {
        checkButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().offset(10)
        }

        taskTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(13)
            $0.leading.equalTo(checkButton.snp.trailing).offset(9)
        }
    }
}

extension CategoryTypeTaskCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let viewModel = viewModel, let indexPath = indexPath, let newText = textField.text else { return }
        let isCompleted = viewModel.item(at: indexPath.item).isCompleted
        
        if newText.isEmpty {
            textField.isEnabled = !isCompleted
            checkButton.isEnabled = isCompleted
        } else {
            textField.isEnabled = isCompleted
            checkButton.isEnabled = !isCompleted
            viewModel.updateItem(at: indexPath.item, with: newText)
            textFieldDidEndEdtingGesture()
        }
    }
}
