//
//  OnboardingCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import UIKit
import SnapKit

class OnboardingCell: UICollectionViewCell {
    private let onboadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ info: OnboardingModel) {
        onboadingImageView.image = UIImage(named: info.imageName)
    }
    
    private func setUI() {
        contentView.addSubview(onboadingImageView)
        
        onboadingImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
