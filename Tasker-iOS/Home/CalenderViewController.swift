//
//  CalenderViewController.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/08.
//

import UIKit
import FSCalendar

final class CalenderViewController: UIViewController {
    private let calender: FSCalendar = FSCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sheet = self.sheetPresentationController else { return }
        
        sheet.detents = [.medium()]
        sheet.selectedDetentIdentifier = .medium
    }
}
