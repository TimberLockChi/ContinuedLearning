//
//  WeakSelfBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/20.
//

import SwiftUI

struct WeakSelfBootcamp: View {
    
    @AppStorage("count") var count: Int?
    
    init(){
        count = 0
    }
    
    var body: some View {
        NavigationView {
            NavigationLink("Navigate") {
                WeakSelfSecondScreen()
                    .navigationTitle("Screen 1")
            }
        }
        .overlay(alignment:.topTrailing) {
            Text("\(count ?? 0)")
                .background(Color.green)
                .padding()
                .background(Color.green.cornerRadius(10))
        }
    }
}

struct WeakSelfSecondScreen: View{
    
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    var body: some View{
        VStack {
            Text("Second View")
                .font(.largeTitle)
            .foregroundColor(.red)
            
            if let data = vm.data{
                Text(data)
            }
        }
    }
}

class WeakSelfSecondScreenViewModel:ObservableObject{
    @Published var data: String? = nil
    
    init() {
        print("Initialize Now")
        let currentCountNow = UserDefaults.standard.integer(forKey: "count")//获取AppStorage存储的本地变量
        UserDefaults.standard.set(currentCountNow+1,forKey: "count")
        getData()
    }
    
    deinit{
        print("Deinitialize Now")
        let currentCountNow = UserDefaults.standard.integer(forKey: "count")//获取AppStorage存储的本地变量
        UserDefaults.standard.set(currentCountNow-1,forKey: "count")
    }
    
    func getData(){
        //执行下载等耗时任务时，如果使用self.xxxx这类强引用，可能会造成数据的多次加载
        //self.xxxx表示对此类/结构体的强引用，表示此任务在结束之前，需要保证类/结构体实例一直保持存活，但是用户可能会退出当前页面或做其他操作，每次初始化时都会执行一遍耗时操作，并且程序不会自动取消上一次耗时操作，从而造成资源消耗较高
        //[weak self] 可以使self变成弱引用，从而可以在用户退出此界面时将耗时任务实例回收掉，因此在进行一步网络下载数据时，尝试经常使用弱引用
        //注意self要加？
        DispatchQueue.main.asyncAfter(deadline: .now()+50){[weak self] in
            self?.data = "New Data!!"
        }
        
    }
}


struct WeakSelfBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        WeakSelfBootcamp()
    }
}
