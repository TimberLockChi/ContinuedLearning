//
//  ScrollViewReaderBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI

struct ScrollViewReaderBootcamp: View {
    
    @State var textFieldText: String = ""
    @State var scrollToIndex:Int = 0
    
    var body: some View {
        VStack{
            VStack{
                TextField("Enter a # here...",text: $textFieldText)
                    .frame(height: 55)
                    .border(Color.gray)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)//只能输入数字
                Button("Click here to go to ...") {
                    //使目标定位到屏幕的哪个位置
                    if let index = Int(textFieldText){
                        scrollToIndex = index
                    }
                }
            }
            ScrollView{
                ScrollViewReader { proxy in
                    //移动时无法移动至不存在的index处
                    ForEach(0..<50){ index in
                        Text("This is item #\(index)")
                            .font(.headline)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .id(index)//给每个item赋一个id
                    }
                    //监听变量变化，scrollToIndex变化时，代理将列表下滑至指定位置
                    .onChange(of: scrollToIndex) { value in
                        withAnimation(.spring()) {
                            proxy.scrollTo(value,anchor: .center)
                        }
                    }
                }
            }
            
        }
    }
}

struct ScrollViewReaderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReaderBootcamp()
    }
}
