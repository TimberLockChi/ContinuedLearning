//
//  BackgroundThreadBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/18.
//

import SwiftUI

class BackgroundThreadViewModel:ObservableObject{
    
    @Published var dataArray:[String] = []
    
    func fetchData(){
        //异步线程执行
        //qos:
        //.userInitiated:表示那些用户在此任务完成前无法使用app的任务
        //.userInteractive:表示用来执行用户的一些交互操作，例如动画等
        //.utility:可以让用户无感知任务的执行
        DispatchQueue.global(qos: .background).async {
            let newData = self.downloadData()
            print("Check 1:\(Thread.isMainThread)")//判断当前进程是否是主线程
            print("Check 1:\(Thread.current)")//得到当前线程的类型
            
            DispatchQueue.main.async {
                //如果要进行界面变更，必须要切换到主线程执行
                //转到主线程执行界面更新操作
                self.dataArray = newData
                print("Check 1:\(Thread.isMainThread)")
                print("Check 1:\(Thread.current)")
            }
        }
    }
    
    func downloadData() -> [String]{
        var data: [String] = []
        for x in 0..<100 {
            data.append("\(x)")
        }
        return data
    }
}

struct BackgroundThreadBootcamp: View {
    
    @StateObject var vm = BackgroundThreadViewModel()
    
    var body: some View {
        ScrollView{
            LazyVStack(spacing:10){
                Text("Load Data")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        vm.fetchData()
                    }
                ForEach(vm.dataArray,id:\.self){ item in
                    Text(item)
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct BackgroundThreadBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundThreadBootcamp()
    }
}
