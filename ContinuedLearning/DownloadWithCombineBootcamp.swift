//
//  DownloadWithCombineBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/22.
//

import SwiftUI
import Combine
struct PostModel:Identifiable,Codable{
    let userId:Int
    let id:Int
    let title:String
    let body:String
}


class DownloadWithCombineViewModel:ObservableObject{
    
    @Published var posts:[PostModel] = []
    //存储Publisher的变量，可以通过对其进行操作控制订阅事件
    var cancellables = Set<AnyCancellable>()
    
    let url:String = "https://jsonplaceholder.typicode.com/posts"
    
    init(){
        getPosts()
    }
    
    func getPosts(){
        //Combine使用流程
        
        // 1. 创建数据任务订阅者Publisher
        // 2. 在后台线程订阅Publisher
        // 3. 在主线程接收订阅者接收到的信息
        // 4. 使用Trymap检查数据是否征程
        // 5. 使用Decoder对JSON数据进行解码至对应的类型
        // 6. 使用Sink将数据应用到程序中
        // 7. 使用AnyCancellable存储Publisher，并对其进行操作
        
        guard let url = URL(string: url) else {return}
        
        //创建Publisher
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))//将Publisher订阅至后台线程
            .receive(on: DispatchQueue.main)//在主线程接收返回结果
            .tryMap (handleOutput)//处理数据输出
            .decode(type: [PostModel].self, decoder: JSONDecoder())//设置解码器和解码模板
            .sink { completion in
                //可以放置成功/错误处理逻辑
                switch completion{
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("There was an error. \(error)")
                }
            } receiveValue: {[weak self] returnPosts in
                self?.posts = returnPosts//避免使用强应用，防止多次执行后台耗时线程
            }
            .store(in: &cancellables)//存储Publisher，可以通过AnyCancellable操作Publisher

    }
    
    func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data{
        //检查数据是否正确，是否出现错误
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else{
            throw URLError(URLError.badServerResponse)
        }
        return output.data
    }
}

struct DownloadWithCombineBootcamp: View {
    
    @StateObject var vm = DownloadWithCombineViewModel()
    
    var body: some View {
        List{
            ForEach(vm.posts){ item in
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(.headline)
                    Text(item.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth:.infinity,alignment: .leading)
            }
        }
    }
}

struct DownloadWithCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithCombineBootcamp()
    }
}
