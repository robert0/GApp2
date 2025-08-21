//
//  Toast.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation
import SwiftUI
import Combine

enum ToastSeverity {
    case info
    case warning
    case error
    case success
}

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let severity: ToastSeverity
    var isVisible: Bool = true
}

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    @Published var toasts: [ToastMessage] = []
    private var timers: [UUID: AnyCancellable] = [:]

    // Static show method
    static func show(_ message: String, _ severity: ToastSeverity) {
        shared.show(message, severity)
    }
    
    func show(_ message: String, _ severity: ToastSeverity) {
        let toast = ToastMessage(text: message, severity: severity)
        toasts.append(toast)
        timers[toast.id] = Just(())
            .delay(for: .seconds(1.0), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                 if let idx = self.toasts.firstIndex(where: { $0.id == toast.id }) {
                     withAnimation(.easeInOut(duration: 0.5)) {
                         self.toasts[idx].isVisible = false
                     }
                     // Remove after fade out
                     let toastToRemove = self.toasts[idx]
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                         self.remove(toastToRemove)
                     }
                 }
            }
    }

    func remove(_ toast: ToastMessage) {
        toasts.removeAll { $0 == toast }
        timers[toast.id]?.cancel()
        timers.removeValue(forKey: toast.id)
    }
}

struct ToastView: View {
    let message: ToastMessage
    let onClose: () -> Void

    private func backgroundColor(for severity: ToastSeverity) -> Color {
        switch severity {
        case .info: return Color(0x00A5E3).opacity(0.2)
        case .warning: return Color.orange.opacity(0.2)
        case .error: return Color.red.opacity(0.2)
        case .success: return Color.green.opacity(0.2)
        }
    }
    
    private func borderColor(for severity: ToastSeverity) -> Color {
        switch severity {
        case .info: return Color(0x00A5E3).opacity(1.0)
        case .warning: return Color.orange.opacity(1.0)
        case .error: return Color.red.opacity(1.0)
        case .success: return Color.green.opacity(1.0)
        }
    }
    
    var body: some View {
        HStack {
            Text(message.text)
                .foregroundColor(Color(0x505050))
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(backgroundColor(for: message.severity))
        .border(borderColor(for: message.severity))
        .cornerRadius(8)
        //.shadow(color: Color.gray, radius: 5, x: 3, y: 3)
        .padding(.horizontal)
        .opacity(message.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.5), value: message.isVisible)
    }
}

struct ToastsContainerView: View {
    @EnvironmentObject var toastManager: ToastManager

    var body: some View {
        VStack {
            //on top of the screen
            Spacer()
            ForEach(toastManager.toasts) { toast in
                ToastView(message: toast) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        if let idx = toastManager.toasts.firstIndex(where: { $0.id == toast.id }) {
                            toastManager.toasts[idx].isVisible = false
                            
                            // Remove after fade out
                            let toastToRemove = toastManager.toasts[idx]
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                toastManager.remove(toastToRemove)
                            }
                        }
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            //on bottom of the screen
//            ForEach(toastManager.toasts) { toast in
//                ToastView(message: toast) {
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        if let idx = toastManager.toasts.firstIndex(where: { $0.id == toast.id }) {
//                            toastManager.toasts[idx].isVisible = false
//                            let toastToRemove = toastManager.toasts[idx]
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                toastManager.remove(toastToRemove)
//                            }
//                        }
//                    }
//                }
//                .transition(.move(edge: .top).combined(with: .opacity))
//            }
//            Spacer()
            
        }
        .padding(.bottom, 40)
        .zIndex(1)
    }
}
