//
//  NoteCell.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/28.
//

import UIKit
import SnapKit

protocol TextViewDidChangeDelegate: AnyObject {
    func textViewDidChangeHeight(_ height: CGFloat, forIndexPath indexPath: IndexPath)
}

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
        textView.font = .pretendardFont(size: 13, style: .regular)
        textView.textColor = .setColor(.gray250)
        textView.backgroundColor = .setColor(.note)
        textView.textAlignment = .left
        return textView
    }()
    
    weak var delegate: TextViewDidChangeDelegate?

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
    
    func configure(_ viewModel: DetailViewModel, indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath.item)
        if noteTextView.text.isEmpty {
            noteTextView.text = "노트를 작성하세요."
        } else {
            noteTextView.text = item.noteText
        }
        
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
            $0.bottom.equalToSuperview().inset(14)
        }
    }
}

extension NoteCollectionViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
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
        guard let textHeight = textView.font?.pointSize else { return }

        let sizeToFit = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = max(sizeToFit.height, textHeight)
        delegate?.textViewDidChangeHeight(newHeight, forIndexPath: IndexPath())
    }
}
