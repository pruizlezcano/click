//
//  ToogleView.swift
//  click
//
//  Created by Pablo Ruiz on 25/8/24.
//

import SwiftUI

struct ToggleView: View {
    let elementMinHeight: CGFloat = 34
    let horizontalPadding: CGFloat = 8
    let iconSize: CGFloat = 24

    let title: LocalizedStringKey
    @Binding var value: Bool

    let disabled: Bool
    @State var isShowingDescription: Bool = false

    public init(
        _ title: LocalizedStringKey,
        isOn value: Binding<Bool>,
        disabled: Bool = false
    ) {
        self.title = title
        _value = value
        self.disabled = disabled
    }

    public var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(title)
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Toggle("", isOn: $value.animation(.default))
                .labelsHidden()
                .controlSize(.small)
                .toggleStyle(.switch)
                .disabled(disabled)
        }
        .padding(.horizontal, horizontalPadding)
        .frame(minHeight: elementMinHeight)
    }
}

#Preview {
    VStack(spacing: 20) {
        ToggleView("Enabled Toggle", isOn: .constant(true))
        ToggleView("Disabled Toggle", isOn: .constant(false), disabled: true)
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
