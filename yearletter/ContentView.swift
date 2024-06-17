//
//  ContentView.swift
//  yearletter
//
//  Created by 김아인 on 6/17/24.
//

import SwiftUI

struct RoughTextureView: View {
    var body: some View {
        Image("background_texture")
            .resizable(capInsets: EdgeInsets(), resizingMode: .tile)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct LinedTextEditor: View {
    @Binding var text: String
    var lineCount: Int = 8
    var body: some View {
        ZStack(alignment: .topLeading) {
            LineBackground(lineCount: lineCount)
                .padding(.horizontal, 4)
            TextEditor(text: $text)
                .font(.custom("GamjaFlower-Regular", size: 20))
                .foregroundColor(Color(hex: "333333"))
                .lineSpacing(13)
                .padding(4)
                .padding(.top, -16)
        }
    }
}

struct LineBackground: View {
    var lineCount: Int
    
    var body: some View {
        GeometryReader { geometry in
            let lineHeight = geometry.size.height / CGFloat(lineCount)
            VStack(spacing: 0) {
                ForEach(0..<lineCount) { _ in
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.vertical, lineHeight / 2)
                }
            }
        }
    }
}

struct ContentView: View {
    @State var userAnswer: String = ""
    var body: some View {
        ZStack{
            RoughTextureView()
                .ignoresSafeArea()
            VStack {
                Text("1년 후 나에게")
                    .font(.custom("GamjaFlower-Regular", size: 22))
                    .foregroundColor(Color(hex: "333333"))
                Text("365일, 365개 질문")
                    .font(.custom("GamjaFlower-Regular", size: 16))
                    .foregroundColor(Color.secondary)
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        Text("2024년 6월 17일,")
                            .font(.custom("GamjaFlower-Regular", size: 16))
                            .foregroundColor(Color.secondary)
                            .padding(.bottom, 8)
                        Text("맛있는 음식을 먹을 때 가장 먼저 생각나는 사람은 누구야?")
                            .font(.custom("GamjaFlower-Regular", size: 20))
                            .foregroundColor(Color(hex: "333333"))
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .padding(.top, 4)
                .padding(.bottom, 20)
                ZStack{
                    if(userAnswer.isEmpty){
                        VStack{
                            HStack{
                                Text("너의 생각을 알려줘.")
                                    .font(.custom("GamjaFlower-Regular", size: 20))
                                    .foregroundColor(Color.secondary)
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(height: 290)
                        .padding(.top, -13)
                        .padding(.horizontal, 9)
                    }
                    LinedTextEditor(text: $userAnswer)
                        .foregroundColor(Color.black)
                        .frame(height: 296)
                        .scrollContentBackground(.hidden)
                }
                Spacer()
                Button(action: {
                    
                }, label: {
                    HStack{
                        Spacer()
                        Text("다 썼어, 저장할게.")
                            .font(.custom("GamjaFlower-Regular", size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(Color(hex: "333333"))
                    .cornerRadius(10)
                })
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
