//
//  ContentView.swift
//  umidade
//
//  Created by Turma02-2 on 07/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var umidade: Umidade? = nil
    
    var body: some View {
        VStack {
            Text("Umidade: \(umidade?.valor ?? 0)")
                .padding()
            
            Button("Atualizar") {
                Task {
                    await fetchUmidade()
                }
            }
        }
    }
    
    func fetchUmidade() async {
        guard let url = URL(string: "http://192.168.128.69:1880/umidade") else {
            print("URL inválida")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let umidade = try JSONDecoder().decode(Umidade.self, from: data)
            await MainActor.run {
                self.umidade = umidade
            }
        } catch {
            print("Erro ao buscar dados: \(error)")
        }
    }
}
#Preview {
    ContentView()
}
