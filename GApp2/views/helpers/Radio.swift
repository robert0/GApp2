//
//  Radio.swift
//  GApp2
//
//  Created by Robert Talianu on 21.02.2025.
//


//
//  RadioButtonGroup.swift
//
//  Created by Frank Lin on 2025/1/21.
//

import SwiftUI

struct Radio: View {
    @Binding var isSelected: Bool
    var len: CGFloat = 30
    private var onTapReceive: TapReceiveAction?
    
    var outColor: Color {
        isSelected == true ? Color.blue : Color.gray
    }
    var innerRadius: CGFloat {
        isSelected == true ? 9 : 0
    }

    var body: some View {
        Circle()
            .stroke(outColor, lineWidth: 1.5)
            .padding(4)
            .overlay() {
                if isSelected {
                    Circle()
                        .fill(Color.blue)
                        .padding(innerRadius)
                        .animation(.easeInOut(duration: 2), value: innerRadius)
                } else {
                    EmptyView()
                }
            }
            .frame(width: len, height: len)
            .onTapGesture {
                withAnimation {
                    isSelected.toggle()
                    onTapReceive?(isSelected)
                }
            }
    }
}

extension Radio {
    typealias TapReceiveAction =  (Bool) -> Void
    
    init(isSelected: Binding<Bool>, len: CGFloat = 30) {
        _isSelected = isSelected
        self.len = len
    }

    init(isSelected: Binding<Bool>, onTapReceive: @escaping TapReceiveAction) {
        _isSelected = isSelected
        self.onTapReceive = onTapReceive
    }
}

public struct RadioButtonGroup<V: Hashable, Content: View>: View {
    private var value: RadioValue<V>
    private var items: () -> Content

    @ViewBuilder
    public var body: some View {
        VStack {
            items()
        }.environmentObject(value)
    }
}

extension RadioButtonGroup where V: Hashable, Content: View {
    init(value: Binding<V?>, @ViewBuilder _ items: @escaping () -> Content) {
        self.value = RadioValue(selection: value)
        self.items = items
    }
}

fileprivate
class RadioValue<T: Hashable>: ObservableObject {
    @Binding var selection: T?

    init(selection: Binding<T?>) {
        _selection = selection
    }
}

fileprivate
struct RadioItemModifier<V: Hashable>: ViewModifier {
    @EnvironmentObject var value: RadioValue<V>
    private var tag: V
    init(tag: V) {
        self.tag = tag
    }
    func body(content: Content) -> some View {
        Button {
            value.selection = tag
        } label: {
            HStack {
                Text("\(tag):")
                content
            }
        }
    }
}

extension View {
    func radioTag<V: Hashable>(_ v: V) -> some View {
        self.modifier(RadioItemModifier(tag: v))
    }
}

//struct RadioButtonGroup_Preview: View {
//    @State var selection: String? = "1"
//    var body: some View {
//        RadioButtonGroup(value: $selection) {
//            Text("radio A")
//                .radioTag("1")
//            Text("radio B")
//                .radioTag("2")
//        }
//    }
//}
//
//#Preview {
//    RadioButtonGroup_Preview()
//}
