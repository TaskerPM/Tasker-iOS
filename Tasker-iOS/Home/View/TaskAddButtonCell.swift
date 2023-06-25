//
//  TaskAddButtonCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/26.
//

import UIKit
import SnapKit

final class TaskAddButtonCell: UICollectionViewCell {
    private var viewModel: TaskViewModel?
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Home_add_task")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addCellLabel: UILabel = {
        let label = UILabel()
        label.text = "추가"
        label.font = .pretendardFont(size: 12, style: .regular)
        label.textColor = .setColor(.gray250)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderColor = UIColor.setColor(.gray30).cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [plusImageView, addCellLabel]
            .forEach(contentView.addSubview)
    }
    
    private func configureLayout() {
        plusImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        addCellLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(12)
            $0.centerY.equalTo(plusImageView.snp.centerY)
        }
    }
}
