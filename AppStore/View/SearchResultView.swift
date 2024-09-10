//
//  SearchResultView.swift
//  AppStore
//
//  Created by 김주희 on 9/10/24.
//

import SwiftUI

struct SearchResultView: View {
    
    let apps: [AppData]
    
    var body: some View {
                    
        ZStack {
            VStack(spacing: 0) {
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                List(apps) { app in
                    VStack(alignment: .leading, spacing: 30) {
                        HStack {
                            AsyncImage(url: URL(string: app.artworkUrl100)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(uiColor: .systemGray6))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(app.trackName)
                                    .font(.system(size: 15))
                                
                                HStack {
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                            StarView(isFilled: index < Int(app.averageUserRating ?? 0))
                                                .frame(width: 12, height: 12)
                                        }
                                    }
                                    
                                    Text(formattedRatingCount(app.userRatingCount ?? 0))
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(uiColor: .systemGray2))
                                }
                            }
                        }
                        
                        HStack(spacing: 10) {
                            ForEach(app.screenshotUrls.prefix(3), id: \.self) { url in
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(uiColor: .systemGray6))
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                        }
                        .isHidden(hidden: app.screenshotUrls.isEmpty, remove: true)
                    }
                    .listRowSeparator(.hidden)
                    .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 10))
                    .background(
                        NavigationLink("", destination: AppDetailView(app: app))
                            .opacity(0)
                    )
                }
                .listStyle(.plain)
            }
            
            Text("검색 결과가 없습니다.")
                .font(.system(size: 18).bold())
                .foregroundStyle(Color(uiColor: .systemGray))
                .isHidden(hidden: apps.count != 0, remove: true)
        }
        .background(Color.white)
    }
}

