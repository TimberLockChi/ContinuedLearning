//
//  LongPressGestureBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/9.
//

import SwiftUI

struct LongPressGestureBootcamp: View {
    
    @State var isComplete: Bool = false
    @State var isSuccess: Bool = false
    
    var body: some View {
        VStack{
            Rectangle()
                .fill(isSuccess ? Color.green : Color.blue)
                .frame(maxWidth: isComplete ? .infinity : 0)//变更大小
                .frame(height: 55)
                .frame(maxWidth: .infinity,alignment:.leading)//有重复设置宽高的话，将后一个设置作为背景叠加
                .background(Color.gray)
            
            Text("Click Here")
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .onLongPressGesture(
                    minimumDuration: 1.0,
                    maximumDistance: 50
                ){ isPressing in
                    //从开始按压到最短按压时间这段时间内进行的操作
                    if isPressing{
                        //一秒钟的时间缓慢变更，对应长按1s
                        withAnimation(.easeInOut(duration: 1.0)){
                            isComplete = true
                        }
                    }else{
                        // 松开手指则0.1秒以后开始回退
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                            if !isSuccess{
                                //回退成失败状态
                                withAnimation(.easeInOut) {
                                    isComplete = false
                                }
                            }
                        }
                    }
                } perform:{
                    //超过最短按压时间后
                    withAnimation(.easeInOut){
                        isSuccess = true
                    }
                }
            //重置
            Text("REST")
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .onTapGesture {
                    isComplete = false
                    isSuccess = false
                }
        }
        
        
//        Text(isComplete ? "Completed" : "Not Complete")
//            .padding()
//            .padding(.horizontal)
//            .background(isComplete ? .green : .gray)
//            .cornerRadius(10)
//            .onLongPressGesture(minimumDuration: 1.0,maximumDistance: 50) {
//                isComplete.toggle()
//            }//minimumDuration定制最小长按时长;maximumDistance定制长按后最大可移动的距离
////            .onTapGesture {
////                isComplete.toggle()
////            }
    }
}

struct LongPressGestureBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        LongPressGestureBootcamp()
    }
}
