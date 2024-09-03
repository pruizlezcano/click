//
//  SettingsSlider.swift
//  click
//
//  Created by Pablo Ruiz on 3/9/24.
//

import SwiftUI

struct SettingsSlider: View {
    let elementMinHeight: CGFloat = 34
    let horizontalPadding: CGFloat = 8

    let title: LocalizedStringKey
    @Binding var value: Float

    let disabled: Bool
    let range: ClosedRange<Float>
    let step: Float
    let leftIcon: String?
    let rightIcon: String?

    public init(
        _ title: LocalizedStringKey,
        value: Binding<Float>,
        disabled: Bool = false,
        in range: ClosedRange<Float> = 0 ... 5,
        step: Float = 0.5,
        leftIcon: String? = nil,
        rightIcon: String? = nil
    ) {
        self.title = title
        _value = value
        self.disabled = disabled
        self.range = range
        self.step = step
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }

    public var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(title)
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()

            if let leftIcon {
                Image(systemName: leftIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 12)
                    .foregroundStyle(disabled ? .tertiary : .secondary)
            }
            Slider(value: $value, in: range, step: step)
                .disabled(disabled)
                .controlSize(.small)
                .frame(maxWidth: 150)
            if let rightIcon {
                Image(systemName: rightIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 12)
                    .foregroundStyle(disabled ? .tertiary : .secondary)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .frame(minHeight: elementMinHeight)
    }
}

#Preview {
    VStack(spacing: 20) {
        SettingsSlider("Custom volume", value: .constant(3), leftIcon: "speaker.fill", rightIcon: "speaker.wave.3.fill")
        SettingsSlider("Custom volume", value: .constant(3), disabled: true, leftIcon: "speaker.fill", rightIcon: "speaker.wave.3.fill")
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
