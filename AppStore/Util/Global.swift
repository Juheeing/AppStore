//
//  Global.swift
//  AppStore
//
//  Created by 김주희 on 9/8/24.
//

import Foundation

class Global: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    func showLoading() {
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
    }
}
