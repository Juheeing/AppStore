//
//  DetailViews.swift
//  AppStore
//
//  Created by 김주희 on 9/10/24.
//

import SwiftUI

struct AppDetailView: View {
    @State private var showTitle: Bool = false
    let app: AppData

    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading) {
                        AppDetailTitleView(app: app)
                        Divider()
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                        SummaryView(app: app)
                        Divider()
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                        NewFeaturesView(app: app)
                        Divider()
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                        ScreenView(app: app)
                        Divider()
                            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                        DescriptionView(app: app)
                    }
                    .frame(maxHeight: .infinity)
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                updateTitleVisibility(geo: geo)
                            }
                            .onChange(of: geo.frame(in: .global).minY) { _ in
                                updateTitleVisibility(geo: geo)
                            }
                    })
                }
            }
            .navigationTitle(showTitle ? app.trackName : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if showTitle {
                        AsyncImage(url: URL(string: app.artworkUrl100)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(uiColor: .systemGray6))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
            }
        }
    }

    private func updateTitleVisibility(geo: GeometryProxy) {
        let offset = geo.frame(in: .global).minY
        showTitle = offset < -10
    }
}

struct AppDetailTitleView: View {
    
    let app: AppData
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: app.artworkUrl100)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .systemGray6))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(app.trackName)
                    .font(.system(size: 20).bold())
                
                Text(app.sellerName)
                    .font(.system(size: 15))
                    .foregroundStyle(Color(uiColor: .systemGray))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("받기")
                        .frame(width: 70, height: 30)
                        .font(.system(size: 16).bold())
                        .foregroundStyle(Color.white)
                        .background(Color(uiColor: .systemBlue), in: Capsule())
                }
            }
            
            Spacer()
        }
        .padding(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct SummaryView: View {
    
    let app: AppData
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                SummaryCell(app: app, title: "\(formattedRatingCount(app.userRatingCount ?? 0))개의 평가", main: String(format: "%.1f", app.averageUserRating ?? 0.0), sub: "*")
                Divider()
                    .padding()
                SummaryCell(app: app, title: "연령", main: app.contentAdvisoryRating, sub: "세")
                Divider()
                    .padding()
                SummaryCell(app: app, title: "개발자", main: "", sub: app.sellerName)
                Divider()
                    .padding()
                SummaryCell(app: app, title: "언어", main: getPreferredLanguage(app.languageCodesISO2A), sub: getLangCount(app.languageCodesISO2A))
            }
        }
        .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

struct SummaryCell: View {
    
    let app: AppData
    var title: String
    var main: String
    var sub: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(Color(uiColor: .systemGray2))
                .lineLimit(1)
            
            if main == "" {
                Image(systemName: "person.crop.square")
                    .font(.system(size: 20))
                    .foregroundStyle(Color(uiColor: .systemGray))
            } else {
                Text(main)
                    .font(.system(size: 20).bold())
                    .foregroundStyle(Color(uiColor: .systemGray))
            }
            
            if sub == "*" {
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        StarView(isFilled: index < Int(app.averageUserRating ?? 0))
                            .frame(width: 12, height: 12)
                    }
                }
            } else {
                Text(sub)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(uiColor: .systemGray))
                    .lineLimit(1)
            }
        }
        .frame(width: 80)
        .frame(maxWidth: 100)
    }
}

struct NewFeaturesView: View {
    
    let app: AppData
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 15) {
                Text("새로운 기능")
                    .font(.system(size: 20).bold())
                
                Text("버전 \(app.version)")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(uiColor: .systemGray2))
                
                Text(isExpanded ? app.releaseNotes : truncatedText(text: app.releaseNotes))
                    .font(.system(size: 15))
                    .lineSpacing(10)
                    .frame(maxHeight: .infinity)
                    .animation(.easeInOut, value: isExpanded)
            }
            HStack {
                Spacer()
                if !isExpanded && numberOfNewLines(text: app.releaseNotes) > 2 {
                    Button {
                        isExpanded.toggle()
                    } label: {
                        Text("더 보기")
                            .font(.system(size: 15))
                            .foregroundColor(Color(uiColor: .systemBlue))
                    }
                }
            }
        }
        .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ScreenView: View {
    
    let app: AppData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("미리보기")
                .font(.system(size: 20).bold())
                .padding(.leading, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(app.screenshotUrls, id: \.self) { url in
                        AsyncImage(url: URL(string: url)) { image in
                            image.resizable()
                                .frame(width: 250, height: 450)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(uiColor: .systemGray6))
                                .frame(width: 250, height: 450)
                        }
                    }
                }
                .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                .frame(maxHeight: .infinity)
            }
        }
        .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct DescriptionView: View {
    
    let app: AppData
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                Text(isExpanded ? app.description : truncatedText(text: app.description))
                    .font(.system(size: 15))
                    .lineSpacing(10)
                    .frame(maxHeight: .infinity)
                    .animation(.easeInOut, value: isExpanded)
                HStack {
                    Spacer()
                    if !isExpanded && numberOfNewLines(text: app.description) > 2 {
                        Button {
                            isExpanded.toggle()
                        } label: {
                            Text("더 보기")
                                .font(.system(size: 15))
                                .foregroundColor(Color(uiColor: .systemBlue))
                        }
                    }
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(app.sellerName)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(uiColor: .systemBlue))
                    Text("개발자")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(uiColor: .systemGray2))
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(uiColor: .systemGray))
            }
        }
        .padding(.init(top: 10, leading: 20, bottom: 30, trailing: 20))
        .fixedSize(horizontal: false, vertical: true)
    }
}
