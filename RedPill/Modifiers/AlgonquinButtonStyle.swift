//
//  AlgonquinButtonStyle.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//

import SwiftUI

struct AlgonquinButtonStyle: ViewModifier {
  let backgroundColor: Color
  let disabled: Bool
  
  func body(content: Content) -> some View {
    content
      .bold()
      .frame(maxWidth: .infinity)
      .padding()
      .background(disabled ? Color.gray : backgroundColor)
      .foregroundColor(.black)
      .cornerRadius(8)
      .opacity(disabled ? 0.6 : 1.0)
      .allowsHitTesting(!disabled)
  }
}

extension View {
  func algonquinButtonStyle(backgroundColor: Color, disabled: Bool = true) -> some View {
    self.modifier(AlgonquinButtonStyle(backgroundColor: backgroundColor, disabled: disabled))
  }
}

#Preview {
  Button("Please, click!") { }
    .algonquinButtonStyle(backgroundColor: .red)
    .padding()
}
