//
//  MagnificationGestureBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI

struct MagnificationGestureBootcamp: View {
    
    
    @State var currentAmount: CGFloat = 0
    @State var lastAmount:CGFloat = 0
    @State var moveX: CGFloat = 0
    @State var moveY: CGFloat = 0
    
    
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Circle()
                    .frame(width: 35,height: 35)
                Text("Swiftful Thinking")
                Spacer()
                Image(systemName: "ellipsis")
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 300)
                //.offset(x:moveX,y: moveY)//拖拉
                .scaleEffect(1 + currentAmount)
                .gesture(
                    MagnificationGesture()
                        .onChanged({ value in
                            currentAmount = value - 1
                        })
                        .onEnded({ value in
                            withAnimation(.spring()){
                                currentAmount = 0
                            }

                        })
                )
//                .gesture(
//                    //拖拉
//                    DragGesture()
//                        .onChanged({value in
//                            withAnimation(.easeInOut){
//                                moveX = value.location.x - value.startLocation.x
//                                moveY = value.location.y -  value.startLocation.y
////                                moveX = value.translation.width
////                                moveY = value.translation.height
//                            }
//                        })
//                        .onEnded({ value in
//                            withAnimation(.easeInOut){
//                                moveX = 0
//                                moveY = 0
//                            }
//                        })
//                    
//                )
            HStack{
                Image(systemName: "heart.fill")
                Image(systemName: "text.bubble.fill")
                Spacer()
            }
            .padding(.horizontal)
            .font(.headline)
            Text("This is the caption for my photo!")
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
        }
        
//        Text("Hello, World!")
//            .font(.title)
//            .padding(40)
//            .background(Color.red.cornerRadius(10))
//            .scaleEffect(1 + currentAmount + lastAmount)
//            .gesture(
//                MagnificationGesture()
//                    .onChanged({ value in
//                        currentAmount = value - 1
//                    })
//                    .onEnded({ value in
//                        lastAmount += currentAmount
//                        currentAmount = 0
//                    })
//
//            )
    }
}

struct MagnificationGestureBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MagnificationGestureBootcamp()
    }
}
