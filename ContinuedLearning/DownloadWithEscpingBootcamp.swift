//
//  DownloadWithEscpingBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/20.
//

import SwiftUI


//struct PostModel:Identifiable,Codable{
//    let userId:Int
//    let id:Int
//    let title:String
//    let body:String
//}

class DownloadWithEscapingViewModel:ObservableObject{
    
    @Published var posts:[PostModel] = []
    
    let url_single:String = "https://jsonplaceholder.typicode.com/posts/1"
    let url_array:String = "https://jsonplaceholder.typicode.com/posts"
    
    init(){
        getPosts()
    }
    
    func getPosts(){
        //下载数据
        guard let url = URL(string: url_array) else {return}
        
        downloadData(fromURL: url) { returnData in
            if let data = returnData {
//                //解码-返回单个数据时
//                guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else{return}
                //解码-返回数据数组时,需要加方括号
                guard let newPost = try? JSONDecoder().decode([PostModel].self, from: data) else{return}
                //进入主线程更新界面
                DispatchQueue.main.async { [weak self] in
//                    //下载单个数据时-会进行UI更新，所以要在主线程进行
//                    self?.posts.append(newPost)
                    //下载多个数据时
                    self?.posts = newPost
                }
            }else{
                print("No data returned.")
            }
        }
    }
    //通用数据下载方法
    func downloadData(fromURL url:URL, handler:@escaping DownloadHandler){
        //请求url数据
        URLSession.shared.dataTask(with: url) { data, response, error in
            //判断是否有数据
            guard let data = data else{
                print("No data")
                return
            }
            //判断是否出现错误
            guard error == nil else{
                print("Error:\(String(describing: error))")
                return
            }
            //判断回复是否有效
            guard let resp = response as? HTTPURLResponse else{
                print("Invalid response.")
                return
            }
            //判断请求是否成功
            guard resp.statusCode >= 200 && resp.statusCode < 300 else{
                print("Status code should be 2xx, but is \(resp.statusCode)")
                return
            }
            handler(data)//对下载的数据进行处理,执行回调函数
        }
        .resume()//正式启动任务
    }
    
}

typealias DownloadHandler = (Data?) -> Void//一定要加？因为Data不是一定会有实际值

struct DownloadWithEscpingBootcamp: View {
    @StateObject var vm = DownloadWithEscapingViewModel()
    var body: some View {
        List{
            ForEach(vm.posts) { post in
                VStack(alignment: .leading){
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
        }
    }
}

struct DownloadWithEscpingBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscpingBootcamp()
    }
}
