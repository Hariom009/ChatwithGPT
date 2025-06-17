//
//  File.swift
//  ChatGPTAppDemo
//
//  Created by Berkay Veysel Ayköse on 9.04.2025.
//
import Foundation
extension ChatView {
    class ViewModel : ObservableObject {
        @Published var messages: [Mesaage] = []

        @Published var currentInput: String = ""
        
        private let openAIService = OpenAlService()
        

        func sendMessage() {

            let newMessage = Mesaage(id: UUID(), role: .user, content: currentInput, createdAt: Date())
            
            
            messages.append(newMessage)
            
            
            currentInput = ""
            Task {
             
                let response = await openAIService.sendMessage(messages: messages)
                

                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("hata")
                    return
                }
                
               
                let receivedMessage = Mesaage(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createdAt: Date())
                
       
                await MainActor.run {
                    messages.append(receivedMessage)
                }
            }
        }
    }
}

struct Mesaage: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createdAt: Date
}
