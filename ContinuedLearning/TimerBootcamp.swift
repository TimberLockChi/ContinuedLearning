//
//  TimerBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/25.
//

import SwiftUI

struct TimerBootcamp: View {
    
    //Timer.publish可以定时发布事件，并在指定的线程中执行所需要的操作
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()//会自动启动
    
    //当前日期
    
    @State var currentDate: Date = Date()
    //日期格式化
    var dateFormatter:DateFormatter{
        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    //计数
    /*
    @State var count:Int = 10
    @State var finishedText:String? = nil
    */
    //日期计数
    /*
    @State var timeRemaining:String = ""
    //得到未来一天的日期
    //byAdding-改变byAdding可以改变目标维度
    let futureDate:Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    //更新剩余时间
    func updateTimeRemaining(){
        //得到距离目标日期的剩余时间
        //[.hour,.minute,.second]表示想得到的信息
        let remaining = Calendar.current.dateComponents([.hour,.minute,.second], from: Date(), to: futureDate)
        let hour = remaining.hour ?? 0
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timeRemaining = "\(hour):\(minute):\(second)"
    }
     */
    //动画计数
    @State var count:Int = 1
    
    var color_light_purple:CGColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    var color_dark_purple:CGColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    
    var body: some View {
        ZStack{
            RadialGradient(
                gradient: Gradient(colors: [Color(color_light_purple),Color(color_dark_purple)]),
                center: .center,
                startRadius: 5,
                endRadius: 500
            )
            .ignoresSafeArea()
            //dateFormatter.string(from: currentDate)//执行日期格式化
            //finishedText ?? "\(count)"//倒计时计数器
            Text(dateFormatter.string(from: currentDate))
                .font(.system(size: 100, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)//保持在一行上
                .minimumScaleFactor(0.1)//如果字数太多可以进行缩放，最小缩放比例是0.1
            //模拟实现三个球的加载动画
//            HStack(spacing:15){
//                Circle()
//                    .offset(y:count == 1 ? 20 : 0)
//                Circle()
//                    .offset(y:count == 2 ? 20 : 0)
//                Circle()
//                    .offset(y:count == 3 ? 20 : 0)
//            }
//            .frame(width:150)
//            .foregroundColor(.white)
            
            //模拟轮播图效果
//            TabView(selection: $count) {
//                Rectangle()
//                    .foregroundColor(.red)
//                    .tag(1)
//                Rectangle()
//                    .foregroundColor(.blue)
//                    .tag(2)
//                Rectangle()
//                    .foregroundColor(.black)
//                    .tag(3)
//                Rectangle()
//                    .foregroundColor(.gray)
//                    .tag(4)
//                Rectangle()
//                    .foregroundColor(.green)
//                    .tag(5)
//                Rectangle()
//                    .foregroundColor(.purple)
//                    .tag(6)
//            }
//            .frame(height: 200 )
//            .tabViewStyle(PageTabViewStyle())
        }
        .onReceive(timer) { value in
            //接收publisher发布的信息，并进行对应的更改
            currentDate = value
//            if count < 1 {
//                finishedText = "Wow"
//            }else{
//                count-=1
//            }
            //updateTimeRemaining()
            //可以时间加载效果
            withAnimation(.easeOut(duration: 1.0)){
                count = count == 6 ? 1 : count + 1
            }
        }
    }
}

struct TimerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TimerBootcamp()
    }
}
