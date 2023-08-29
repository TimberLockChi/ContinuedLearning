//
//  SubscriberBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/28.
//

import SwiftUI
import Combine

class SubscriberViewModel:ObservableObject{
    
    
    @Published var count: Int = 0
    @Published var textFeildText:String = ""
    @Published var textIsValid:Bool = false
    
    @Published var showButton:Bool = false
    
    var timer:AnyCancellable?
    var cancellable = Set<AnyCancellable>()
    init(){
        setUpTimer()
        addTextFieldSubscriber()
        addButtonSubscriber()
    }
    
    func addButtonSubscriber(){
        $textIsValid
            .combineLatest($count)
            .sink { [weak self] isValid , count in
                //isValid表示监听$textIsValid的值变化
                //count表示监听$count的值变化
                guard let self = self else {return }
                if isValid && count >= 10{
                    self.showButton = true
                }else{
                    self.showButton = false
                }
            }
            .store(in: &cancellable)
    }
    
    func addTextFieldSubscriber(){
        $textFeildText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)//减缓事件触发时间，避免在每次变更时都触发，可以延后0.5秒
            .map { text -> Bool in
                if text.count > 3{
                    return true
                }
                return false
            }//map是只获取某些特殊部分的值，此处只取textFeild的文本值，并转化成Bool
            //.assign(to: \.textIsValid, on: self)//将值赋给textIsValid
            .sink(receiveValue: { [weak self] isValid in
                self?.textIsValid = isValid //当接收到返回值时，赋值
            })
            .store(in: &cancellable)
    }
    
    func setUpTimer(){
       Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                //接收到返回值时，进行以下操作
                guard let self = self  else{return}
                self.count += 1
                //如果停止则接收不到任何监听值
//                if self.count >= 10 {
//                    for item in self.cancellable{
//                        //存储在cancellable里的所有publisher都停止运行
//                        item.cancel()
//                    }
//                }
            }
            .store(in: &cancellable)
    }
    
    
    
}

struct SubscriberBootcamp: View {

    @StateObject var vm = SubscriberViewModel()
    let color_textField:CGColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    
    
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            TextField("Typed something here ...",text: $vm.textFeildText)
                .padding(.leading)
                .frame(height: 55)
                .font(.headline)
                .background(Color(color_textField))
                .cornerRadius(10)
                .overlay(alignment:.trailing, content: {
                    ZStack{
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(
                                vm.textFeildText.count < 1 ? 0.0 :
                                vm.textIsValid ? 0.0 : 1.0
                            )
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(vm.textIsValid ? 1.0 : 0.0)
                    }
                    .font(.title)
                    .padding(.trailing)
                })
                .padding(.horizontal)
            Button {
                
            } label: {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .opacity(vm.showButton ? 1.0 : 0.5)
            }
            .disabled(!vm.showButton)
            .padding()

        }
    }
}

struct SubscriberBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SubscriberBootcamp()
    }
}
