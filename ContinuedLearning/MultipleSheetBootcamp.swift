//
//  MultipleSheetBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI

struct RandomModel:Identifiable{
    let id = UUID().uuidString
    let title: String
}

// 1 - use a binding
// 2 - use multiple .sheets
// 3 - use $item

struct MultipleSheetBootcamp: View {
    
    @State var selectedModel: RandomModel? = nil
    
    var body: some View {
        VStack(spacing: 20){
            //如果要为每个按钮定制一个sheet，则需要删除最外层的sheet，因为外部的sheet属于内部sheet的父母sheet，则子sheet无法生效。
            //同级sheet可以存在多个
            Button("Button 1"){
                selectedModel = RandomModel(title: "one")
            }
            Button("Button 2"){
                selectedModel = RandomModel(title: "two")
            }
        }
        //根据数据不同展示不同sheet时，使用对item变化监听的方式唤起sheet
        .sheet(item: $selectedModel) { model in
            //变量发生变化时，弹出sheet
            NextScreen(selectedModel: model)
        }
//        //避免在.sheet中使用逻辑判断，如ifelse
//        .sheet(isPresented: $showSheet) {
//            //此部分在屏幕初始化时就已经初始化完成了
//            NextScreen(selectedModel: selectedModel)
//            //方法1-使用binding根据title的变化改变页面对应的标题
//        }
    }
}
struct NextScreen: View{
    
    //@Binding var selectedModel: RandomModel
    let selectedModel: RandomModel
    
    var body: some View{
        Text(selectedModel.title)
            .font(.largeTitle)
    }
}

struct MultipleSheetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSheetBootcamp()
    }
}
