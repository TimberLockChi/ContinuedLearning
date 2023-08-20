//
//  EscapingBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/20.
//

import SwiftUI

class EscapingViewModel: ObservableObject{
    @Published var text: String = "Hello"
    
    func getData(){
//        downloadData3 {[weak self] data in
//            self?.text  =  data
//        }
        let completion:DownloadCompletion = {[weak self]result in
            self?.text = result.data
            return "A"
        }
        downloadData5(completionHandler: completion)
//        downloadData5 {[weak self] result in
//            self?.text = result.data
//        }
    }
    func downloadData2(completionHandler:(_ data:String)->Void) {
        completionHandler("New Data")
    }
    //@escaping回调方法，当方法中出现耗时操作时，通过回调方法执行
    func downloadData3(completionHandler:@escaping(_ data:String)->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler("New Data!")
        }
    }
    func downloadData4(completionHandler:@escaping(DownloadResult)->Void) {
        let result = DownloadResult(data: "New Data!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler(result)
        }
    }
    //通过别名简化写法
    func downloadData5(completionHandler: @escaping DownloadCompletion){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let result = DownloadResult(data: "New Data!")
            let str:String = completionHandler(result)
            print(str)
        }
    }
}
struct DownloadResult{
    let data: String
}

typealias DownloadCompletion = (DownloadResult) -> String//可以选择有返回值和无返回值的回调函数
//有返回值的回调函数意味着可以得到后续操作的结果
//无返回值的回调函数只是表示在完成某些操作后触发下一步操作

struct EscapingBootcamp: View {
    
    @StateObject var vm = EscapingViewModel()
    
    var body: some View {
        Text(vm.text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .onTapGesture {
                vm.getData()
            }
    }
}

struct EscapingBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        EscapingBootcamp()
    }
}
