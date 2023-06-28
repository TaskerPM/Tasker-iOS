//
//  CategoryTypeHeaderView.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/29.
//

import UIKit
import SnapKit

protocol AddNewCellDelegate: AnyObject {
    func tappedAddCellButton()
}

class CategoryTypeHeaderView: UICollectionReusableView {
    private let categoryLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
        label.text = "스터디"
        label.font = .pretendardFont(size: 12, style: .regular)
        label.textColor = .setColor(.yellowText)
        label.backgroundColor = .setColor(.yellowBg)
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        return label
    }()
    
    private lazy var addCellButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "추가"
        config.attributedTitle?.font = .pretendardFont(size: 12, style: .regular)
        config.baseForegroundColor = .setColor(.gray200)
        config.image = UIImage(named: "Home_add_task")
        config.contentInsets = .init(top: 0.5, leading: 6, bottom: 0.5, trailing: 6)
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.setColor(.gray30).cgColor
        button.layer.cornerRadius = 14
        
        button.configuration = config
        button.addAction(UIAction(handler: { _ in
            self.delegate?.tappedAddCellButton()
        }), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: AddNewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [categoryLabel, addCellButton]
            .forEach(addSubview)
    }
    
    private func configureLayout() {
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        addCellButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
}


