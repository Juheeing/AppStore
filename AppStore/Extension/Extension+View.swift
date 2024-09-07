//
//  Extension+View.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func isHidden(hidden: Bool = false, remove: Bool = false) -> some View {
        modifier(IsHidden(hidden: hidden, remove: remove))
    }
    
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}

struct IsHidden: ViewModifier {
    var hidden = false
    var remove = false
    func body(content: Content) -> some View {
        if hidden {
            if !remove {
                content.hidden()
            }
        } else {
            content
        }
    }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
