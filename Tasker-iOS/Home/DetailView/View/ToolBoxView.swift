//
//  ToolBoxView.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/02.
//

import UIKit
import SnapKit

class ToolBoxView: UIView {
    private let addNoteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "노트 추가하기"
        config.image = UIImage(named: "Home_add_note")
        config.attributedTitle?.font = .pretendardFont(size: 14, style: .regular)
        config.baseForegroundColor = .setColor(.basicRed)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            // TODO: NoteCell 추가하기
            print("Tapped addNoteButton")
        }))
    }()
    
    private let cameraButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Home_camera")
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            // TODO: camera roll 열기 (권한 허용하기)
            print("Tapped cameraButton")
        }))
    }()

    private let albumButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Home_gallery")
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            // TODO: photo library 열고 선택한 사진을 NoteCell에 추가하기 (권한 허용하기)
            print("Tapped albumButton")
        }))
    }()
    
    private let cameraAlbumStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins.right = 7
        return stackView
    }()
    
    private let toolBoxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [cameraButton, albumButton]
            .forEach(cameraAlbumStackView.addArrangedSubview)
        
        [addNoteButton, cameraAlbumStackView]
            .forEach(toolBoxStackView.addArrangedSubview)
        
        addSubview(toolBoxStackView)
    }
    
    private func configureLayout() {
        toolBoxStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
