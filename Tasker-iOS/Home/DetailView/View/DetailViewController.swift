//
//  DetailViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    var dummyDataSource = ["1"]
    
    private let saveButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "저장"
        config.attributedTitle?.font = .pretendardFont(size: 13, style: .semiBold)
        config.baseForegroundColor = .setColor(.gray900)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            // TODO: 저장 버튼을 누르면 컨텐츠를 서버에 저장하는 로직 호출 (뒤로 가기 x)
            print("Tapped saveNote")
        }))
    }()
    
    private let todoTitleTextField: UITextField = {
        let textField = UITextField()
        textField.text = "프로젝트 이름"
        textField.font = .pretendardFont(size: 16, style: .semiBold)
        textField.textColor = .setColor(.basicBlack)
        return textField
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.textColor = .setColor(.black)
        label.font = .pretendardFont(size: 14, style: .regular)
        return label
    }()
    
    private lazy var categorySelectButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "선택 안 함"
        config.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.baseForegroundColor = .setColor(.white)
        config.background.backgroundColor = .setColor(.gray300)
        config.background.cornerRadius = 5
        config.attributedTitle?.font = .pretendardFont(size: 12, style: .regular)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Tapped categorySelectButton")
            let categoryListVC = CategoryListViewController()
            self.navigationController?.pushViewController(categoryListVC, animated: true)
        }))
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = .setColor(.black)
        label.font = .pretendardFont(size: 14, style: .regular)
        return label
    }()
    
    private lazy var timeSelectButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "선택 안 함"
        config.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.baseForegroundColor = .setColor(.white)
        config.background.backgroundColor = .setColor(.gray300)
        config.background.cornerRadius = 5
        config.attributedTitle?.font = .pretendardFont(size: 12, style: .regular)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Tapped timeSelectButton")
            let timePickerVC = TimePickerViewController()
            timePickerVC.modalPresentationStyle = .custom
            timePickerVC.transitioningDelegate = self
            self.present(timePickerVC, animated: true)
        }))
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let topSeperateLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.setColor(.gray30).cgColor
        return view
    }()
   
    private lazy var noteCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let bottomSeperateLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.setColor(.gray30).cgColor
        return view
    }()
    
    private lazy var addNoteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "노트 추가하기"
        config.image = UIImage(named: "Home_add_note")
        config.attributedTitle?.font = .pretendardFont(size: 14, style: .regular)
        config.baseForegroundColor = .setColor(.basicRed)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            let newNote = "\(self.dummyDataSource.count)"
            self.dummyDataSource.append(newNote)
            let indexPath = IndexPath(item: self.dummyDataSource.count - 1, section: 0)
            self.noteCollectionView.insertItems(at: [indexPath])
        }))
    }()
    
    var previousContentOffset: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        
        configureNavigationBar()
        configureUI()
        configureLayout()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        todoTitleTextField.becomeFirstResponder()
    }
    
    private func configureNavigationBar() {
        let navigationBack = UIImage(named: "navigation_back")
        let backBarButton = UIBarButtonItem(image: navigationBack, style: .plain, target: self, action: #selector(popToVC))
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = .setColor(.gray900)
        self.navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @objc func popToVC() {
//        self.navigationController?.popViewController(animated: true)
        print("Tapped popToVC")
    }

    private func configureCollectionView() {
        noteCollectionView.delegate = self
        noteCollectionView.dataSource = self
        noteCollectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: "NoteCollectionViewCell")
    }
    
    private func configureUI() {
        [categoryLabel, categorySelectButton]
            .forEach(categoryStackView.addArrangedSubview)
        
        [timeLabel, timeSelectButton]
            .forEach(timeStackView.addArrangedSubview)
        
        [
            todoTitleTextField, categoryStackView, timeStackView, topSeperateLineView,
            noteCollectionView, bottomSeperateLineView, addNoteButton
        ]
            .forEach(view.addSubview)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        todoTitleTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview().offset(18)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(todoTitleTextField.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        timeStackView.snp.makeConstraints {
            $0.top.equalTo(categoryStackView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        topSeperateLineView.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        noteCollectionView.snp.makeConstraints {
            $0.top.equalTo(topSeperateLineView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        bottomSeperateLineView.snp.makeConstraints {
            $0.top.equalTo(noteCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        addNoteButton.snp.makeConstraints {
            $0.top.equalTo(bottomSeperateLineView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(45)
        }
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as? NoteCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        return cell
    }
}

extension DetailViewController: TextViewDidChangeDelegate {
    func textViewDidChangeHeight(_ height: CGFloat, forIndexPath indexPath: IndexPath) {
        let contentSize = noteCollectionView.contentSize
        let maxContentOffsetY = contentSize.height + noteCollectionView.contentOffset.y + height
        let newContentOffset = CGPoint(x: previousContentOffset.x, y: min(previousContentOffset.y, maxContentOffsetY))
        
        noteCollectionView.contentOffset = newContentOffset
        noteCollectionView.performBatchUpdates {
            previousContentOffset = newContentOffset
        }
    }
}

extension DetailViewController {
    private func configureSwipeAction(_ indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { [weak self] action, view, conpletionHandler in
            guard let self else { return }
            
            let point = view.convert(view.bounds.origin, to: self.noteCollectionView)
            if let indexPath = self.noteCollectionView.indexPathForItem(at: point) {
                self.dummyDataSource.remove(at: indexPath.item)
                self.noteCollectionView.deleteItems(at: [indexPath])
            }
            conpletionHandler(true)
        }
        deleteAction.backgroundColor = .setColor(.basicRed)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            config.trailingSwipeActionsConfigurationProvider = self.configureSwipeAction(_:)
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            section.interGroupSpacing = 18
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalViewPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}
