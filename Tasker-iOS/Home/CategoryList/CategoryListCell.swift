//
//  CategoryListCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/23.
//

import UIKit
import SnapKit

class CategoryListCell: UICollectionViewCell {
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "선택 안 함"
        label.textColor = .setColor(.white)
        label.font = .pretendardFont(size: 14, style: .regular)
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor.setColor(.gray300).cgColor
        label.layer.cornerRadius = 5
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
    
    func configure() {
        
    }
    
    private func configureUI() {
        contentView.addSubview(categoryNameLabel)
    }
    
    private func configureLayout() {
        categoryNameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
