//
//  DetailViewModel.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/26.
//

import UIKit

class DetailViewModel {
    private var notes: [DetailModel] = [DetailModel(noteText: "")]
    
    var itemCount: Int {
        return notes.count
    }
    
    func item(at index: Int) -> DetailModel {
            return notes[index]
        }
    
    func addItem(_ newItem: DetailModel) {
        notes.append(newItem)
    }
    
    func deleteItem(at index: Int) {
        notes.remove(at: index)
    }
    
    func updateItem(at index: Int, with newText: String) {
        notes[index].noteText = newText
    }
}
