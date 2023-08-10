//
//  DragGestureBootcamp2.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI

struct DragGestureBootcamp2: View {
    
    
    @State var startingOffsetY:CGFloat = UIScreen.main.bounds.height * 0.85
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            MySignUpView()
                .offset(y:startingOffsetY)//起始滑动下移至屏幕高度的0.85
                .offset(y:currentDragOffsetY)//当前滑动的距离
                .offset(y:endingOffsetY)//最终位置
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            withAnimation(.spring()){
                                currentDragOffsetY = value.translation.height
                            }
                        })
                        .onEnded({ value in
                            withAnimation(.spring()){
                                //从底部开始拖，小于-150=越往上拖
                                if currentDragOffsetY < -150 {
                                    endingOffsetY = -startingOffsetY
                                    //抵消初始的位置下移，使视图恢复原有的位置
                                }else if endingOffsetY != 0 && currentDragOffsetY > 150{
                                    //位于顶部（endingOffsetY != 0），且向下拖动超过150时（currentDragOffsetY > 150）
                                    endingOffsetY = 0//自动收起（取消对startoffset的影响）
                                }
                                currentDragOffsetY = 0//拖动结束时，取消当前拖动距离的影响，只会停留在两个位置-底部、顶部
                            }
                        })
                )
            Text("\(currentDragOffsetY)")
        }
        .ignoresSafeArea(edges:.bottom)
    }
}

struct DragGestureBootcamp2_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureBootcamp2()
    }
}

struct MySignUpView: View {
    var body: some View {
        VStack(spacing:20){
            Image(systemName: "chevron.up")
                .padding(.top)
            Text("sign up")
                .font(.headline)
                .fontWeight(.semibold)
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100,height: 100)
            
            Text("abcjfas;fadjfjdasfjsajfisadjoigasiofjoiasdfksadfoicsdjaivjcsa")
                .multilineTextAlignment(.center)
            Text("Creat Account")
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .padding(.horizontal)
                .background(Color.black.cornerRadius(10))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
    }
}
