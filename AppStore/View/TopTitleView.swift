//
//  TopTitleView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct TopTitleView: View {
    
    var title: String
    
    var body: some View {
        
        HStack {
            Text(title)
                .font(.system(size: 35).bold())
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 30))
                    .foregroundColor(Color(uiColor: .systemBlue))
            })
        }
    }
}

#Preview {
    TopTitleView(title: "Test")
}
