//
//  CommonViews.swift
//  AppStore
//
//  Created by 김주희 on 9/10/24.
//

import SwiftUI

struct StarView: View {
    
    var isFilled: Bool
    
    var body: some View {
        ZStack {
            Image(systemName: "star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
            
            if isFilled {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
    }
}
