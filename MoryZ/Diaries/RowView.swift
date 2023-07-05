//
//  RowView.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/1.
//

import SwiftUI


struct RowView: View {
    let diary: Diary

    @Environment(\.colorScheme) var colorScheme
    @State var dragAmount = CGFloat.zero
    
    var onSwipeAndTapped: (_ diary: Diary) -> ()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(getDay(date: diary.date!))")
                        .font(.title)
                        .frame(width: Ratio.ListRowLabelWidth.rawValue * UIScreen.main.bounds.width, alignment: .trailing)
                    
                    Text(diary.title!)
                        .font(.title)
                    .lineLimit(1)
                    
                    Spacer()
                    
                    HStack {
                        Text(diary.weather!)
                            .font(.title)
                        
                        Text(diary.mood!)
                            .font(.title)
                        Text(diary.mean!)
                            .font(.title)
                    }
                    .padding(.horizontal)
                    
                    
                }
                
                HStack(alignment: .bottom) {
                    Text(weekdayFromNumToString(weekday: getWeekday(date: diary.date!)))
                        .font(.subheadline)
                        //.foregroundColor(.blue)
                        .frame(width: Ratio.ListRowLabelWidth.rawValue * UIScreen.main.bounds.width, alignment: .trailing)
                    
                    Text(diary.content!)
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .frame(width: UIScreen.main.bounds.width * Ratio.ListRowContentWidth.rawValue, height: UIScreen.main.bounds.height * Ratio.ListRowContentHeight.rawValue, alignment: .topLeading)
                        
                    
                    Spacer()
                    
                    Text(getRawTime(date: diary.lastModifiedTime!))
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .font(.subheadline)
                    
                }
                
                
            }
            .offset(x: dragAmount, y: 0)
            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height * Ratio.RowHeight.rawValue)
            .background((colorScheme == .light) ? .white.opacity(0.5) : .black.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                Color.clear
                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height * Ratio.RowHeight.rawValue)
                Button(action: {
                    onSwipeAndTapped(diary)
                }) {
                    ZStack {
                        Color.red
                        .frame(width: 100, height: UIScreen.main.bounds.height * Ratio.RowHeight.rawValue)
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    
                }
                .offset(x: 50 + dragAmount, y: 0)
                
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height * Ratio.RowHeight.rawValue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .gesture(
            DragGesture()
                .onChanged { newValue in
                    withAnimation {
                        dragAmount = newValue.translation.width
                    }
                    
                }
                .onEnded { newValue in
                    if dragAmount < -100 {
                        withAnimation {
                            dragAmount = -100
                        }
                    } else {
                        withAnimation {
                            dragAmount = .zero
                        }
                    }
                    
                }
        )
        .onDisappear {
            dragAmount = .zero
        }
    }
}
