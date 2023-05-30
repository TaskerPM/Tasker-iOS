//
//  NoteCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/28.
//

import UIKit
import SnapKit

final class NoteCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Note."
        label.textColor = .setColor(.gray250)
        label.font = .pretendardFont(size: 16, style: .semiBold)
        return label
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.text = "노트를 작성하세요."
        textView.font = .pretendardFont(size: 13, style: .regular)
        textView.textColor = .setColor(.gray250)
        textView.backgroundColor = .setColor(.note)
        textView.textAlignment = .left
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .setColor(.note)
        contentView.layer.cornerRadius = 20
        
        noteTextView.delegate = self
        noteTextView.isScrollEnabled = false
        
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabel, noteTextView]
            .forEach(contentView.addSubview)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(18)
        }
        
        noteTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualToSuperview().inset(14)
        }
    }
}

extension NoteCollectionViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .setColor(.gray250) {
            textView.text = nil
            textView.textColor = .setColor(.text)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "노트를 작성하세요."
            textView.textColor = .setColor(.gray250)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let collectionView else { return }
        
        let contentSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        
        if textView.bounds.height != contentSize.height {
            collectionView.contentOffset.y += contentSize.height - textView.bounds.height - titleLabel.bounds.height
            
//            UIView.setAnimationsEnabled(false)
            collectionView.collectionViewLayout.invalidateLayout()

            print("collectionView.contentOffset.y: \(collectionView.contentOffset.y)")
            print("contentSize.height: \(contentSize.height)")
            print("textView.frame.height: \(textView.frame.height)")
            print("titleLabel.frame.height: \(titleLabel.frame.height)")
            print("---------------------------------------------")
        }
    }
}

extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        var view = superview
        while view != nil && !(view is UICollectionView) {
            view = view?.superview
        }

        return view as? UICollectionView
    }
}
