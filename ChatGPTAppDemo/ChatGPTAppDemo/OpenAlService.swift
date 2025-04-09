// OpenAlService.swift
// ChatGPTAppDemo
//
// Created by Berkay Veysel Ayköse on 9.04.2025.
//
import Foundation
import Alamofire

// OpenAlService sınıfı, OpenAI API'ye mesaj göndermek için kullanılır.
class OpenAlService {
    // OpenAI API'nin endpoint URL'si
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"
    
    // Mesajları OpenAI API'ye göndermek için kullanılan fonksiyon
    func sendMessage(messages: [Mesaage]) async -> OpenAIChatResponse? {
        
        // Gönderilen mesajları, OpenAI API'sinin kabul edeceği formata dönüştürür
        let openAImessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        
        // API isteği için body (gönderilecek veri) oluşturuluyor
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAImessages)
        
        // HTTP başlıkları, API anahtarını içeriyor
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.apiKey)" // API Anahtarını burada alıyoruz
        ]
        
        // Alamofire ile HTTP isteği gönderilir
        // Gönderilen isteğin sonucu, OpenAIChatResponse tipiyle serileştirilip döndürülür
        return try? await AF.request(endpointUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}

// OpenAI API'ye gönderilecek body'nin yapısı
struct OpenAIChatBody : Encodable {
    let model : String      // Kullanılacak model, burada "gpt-3.5-turbo"
    let messages : [OpenAIChatMessage]   // Mesajlar dizisi
}

// OpenAI'ye gönderilecek mesajın yapısı
struct OpenAIChatMessage : Codable {
    let role: SenderRole    // Mesajı gönderenin rolü (system, user, assistant)
    let content: String     // Mesaj içeriği
}

// Mesaj gönderenin rolünü belirtir (system, user, assistant)
enum SenderRole : String, Codable  {
    case system
    case user
    case assistant
}

// OpenAI'den dönecek yanıtın yapısı
struct OpenAIChatResponse : Decodable {
    let choices : [OpenAIChatChoice]   // API'den dönen olasılıkların listesi
}

// API'den dönen her bir olasılığın yapısı
struct OpenAIChatChoice : Decodable {
    let message : OpenAIChatMessage  // Mesaj, her bir olasılığın içinde
}
