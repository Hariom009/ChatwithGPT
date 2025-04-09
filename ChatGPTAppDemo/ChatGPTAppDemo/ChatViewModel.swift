//
//  File.swift
//  ChatGPTAppDemo
//
//  Created by Berkay Veysel Ayköse on 9.04.2025.
//
import Foundation

// ChatView modeline eklenen ViewModel
extension ChatView {
    // ViewModel sınıfı, ObservableObject protokolünü benimser
    // Bu sınıf, kullanıcı arayüzüne veri sağlamak için kullanılır
    class ViewModel : ObservableObject {
        // Kullanıcı mesajlarını tutan bir dizi
        @Published var messages: [Mesaage] = []
        // Kullanıcının şu an yazdığı mesaj
        @Published var currentInput: String = ""
        
        // OpenAI servisi ile iletişim sağlamak için bir nesne
        private let openAIService = OpenAlService()
        
        // Mesaj gönderme fonksiyonu
        func sendMessage() {
            // Yeni bir kullanıcı mesajı oluşturuluyor
            let newMessage = Mesaage(id: UUID(), role: .user, content: currentInput, createdAt: Date())
            
            // Mesajı messages dizisine ekleyin
            messages.append(newMessage)
            
            // Kullanıcı girişini sıfırlayın
            currentInput = ""
            
            // Asenkron bir görev başlatılıyor
            Task {
                // OpenAI servisine mesajlar gönderiliyor ve yanıt alınıyor
                let response = await openAIService.sendMessage(messages: messages)
                
                // Gelen yanıttan mesaj alınıyor, eğer alınmazsa hata yazdırılıyor
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("hata")
                    return
                }
                
                // OpenAI'den gelen mesaj ile yeni bir Mesaage nesnesi oluşturuluyor
                let receivedMessage = Mesaage(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createdAt: Date())
                
                // Ana iş parçacığında (UI thread) mesajları güncelleyin
                await MainActor.run {
                    messages.append(receivedMessage)
                }
            }
        }
    }
}

// Mesaage modelinin yapısı
struct Mesaage: Decodable {
    let id: UUID               // Mesajın benzersiz kimliği
    let role: SenderRole       // Mesajı gönderenin rolü (user, assistant vs.)
    let content: String        // Mesajın içeriği
    let createdAt: Date        // Mesajın gönderilme zamanı
}
