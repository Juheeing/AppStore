//
//  TopTitleView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct TopTitleView: View {
    
    var title: String
    var date: Date?
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if let date = date {
                    Text(dateFormatted(date))
                        .font(.system(size: 12).bold())
                        .foregroundColor(Color(uiColor: .systemGray))
                }
                Text(title)
                    .font(.system(size: 35).bold())
            }
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 30))
                    .foregroundColor(Color(uiColor: .systemBlue))
            })
        }
    }
    
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: date)
    }
}

#Preview {
    TopTitleView(title: "Test")
}
