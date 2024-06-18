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
                .toolbar{
                    ToolbarItemGroup(placement: .keyboard){
                        Spacer()
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }, label: {
                            Text("닫기")
                                .font(.custom("GamjaFlower-Regular", size: 18))
                                .foregroundColor(Color(hex: "333333"))
                        })
                    }
                }
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

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        return String(self[startIndex ..< endIndex])
    }
}

struct ContentView: View {
    @State var userAnswer: String = ""
    @State var todayDate: String = "00000000"
    var body: some View {
        ZStack{
            RoughTextureView()
                .ignoresSafeArea()
            VStack {
                Text("1년 후 나에게")
                    .font(.custom("GamjaFlower-Regular", size: 22))
                    .foregroundColor(Color(hex: "333333"))
                Text("우리가 함께한 365일, 지금까지 365개 답변")
                    .font(.custom("GamjaFlower-Regular", size: 16))
                    .foregroundColor(Color.secondary)
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        Text("\(todayDate.substring(from: 0, to: 3))년 \(todayDate.substring(from: 4, to: 5))월 \(todayDate.substring(from: 6, to: 7))일,")
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
        .onAppear{
            print(readTextFile())
            var formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            var current_date_string = formatter.string(from: Date())
            todayDate = current_date_string
        }
    }
    func readTextFile() -> String {
        var result = ""
        guard let pahts = Bundle.main.path(forResource: "question.txt", ofType: nil) else { return "" }
        do {
            result = try String(contentsOfFile: pahts, encoding: .utf8)
            return result
        } catch {
            return "Error: file read failed - \(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}
