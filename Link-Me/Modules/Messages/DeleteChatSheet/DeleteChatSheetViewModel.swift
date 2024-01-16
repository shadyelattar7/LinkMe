//
//  DeleteChatSheetViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/01/2024.
//

import Foundation


class DeleteChatSheetViewModel: BaseViewModel {
    
    // MARK: Inputs
    
    private let chatsID: [Int]
    
    
    // MARK: Init
    
    init(chatsID: [Int]) {
        self.chatsID = chatsID
    }
}

// MARK: Outputs

extension DeleteChatSheetViewModel {
    func getNumberOfChats()-> Int {
        return chatsID.count
    }
}
