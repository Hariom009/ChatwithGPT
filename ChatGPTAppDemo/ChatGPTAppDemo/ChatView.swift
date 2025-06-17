
import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            // Başlık
            Text("ChatwithGPT")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(Color.green.opacity(0.7))
                .padding(.top, 16)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(viewModel.messages.filter({ $0.role != .system }), id: \.id) { message in
                        messageView(message: message)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .padding()

            // Mesaj giriş alanı
            HStack(spacing: 10) {
                TextField("Search Anything", text: $viewModel.currentInput)
                    .font(.system(size: 18))
                    .padding(12)
                    .background(Color(.systemGray5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color(.systemGray5))
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    func messageView(message: Mesaage) -> some View {
        HStack {
            if message.role == .assistant {
                HStack(alignment: .bottom) {
                    Text(message.content)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Spacer()
                }
            } else {
                HStack(alignment: .bottom) {
                    Spacer()
                    Text(message.content)
                        .padding(12)
                        .background(Color.blue.opacity(0.3))
                        .foregroundColor(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal)
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    ChatView()
}
