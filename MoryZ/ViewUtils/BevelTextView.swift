//
//  BevelTextView.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/1.
//

import SwiftUI

struct BevelTextView: View {
    
    let text: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Text(text)
            .frame(width: width, height: height)
            .background(
                ZStack {
                    Capsule()
                        .fill(.blue)
                        .northWestShadow(radius: 3, offset: 1)
                    Capsule()
                        .inset(by: 3)
                        .fill(Color.white)
                        .southEastShadow(radius: 1, offset: 1)
                }
            )
    }
}

struct BevelTextView_Previews: PreviewProvider {
    static var previews: some View {
        BevelTextView(text: "Hello", width: 100, height: 50)
    }
}

extension View {
  /// Simulate shining a light on the northwest edge of a view.
  /// Light shadow on the northwest edge, dark shadow on the southeast edge.
  ///   - parameters:
  ///     - radius: The size of the shadow
  ///     - offset: The value used for (-x, -y) and (x, y) offsets
  func northWestShadow(
    radius: CGFloat = 16,
    offset: CGFloat = 6
  ) -> some View {
    return self
      .shadow(
        color: .white,
        radius: radius,
        x: -offset,
        y: -offset)
      .shadow(
        color: .black, radius: radius, x: offset, y: offset)
  }

  /// Simulate shining a light on the southeast edge of a view.
  /// Light shadow on the southeast edge, dark shadow on the northwest edge.
  ///   - parameters:
  ///     - radius: The size of the shadow
  ///     - offset: The value used for (-x, -y) and (x, y) offsets
  func southEastShadow(
    radius: CGFloat = 16,
    offset: CGFloat = 6
  ) -> some View {
    return self
      .shadow(
        color: .black, radius: radius, x: -offset, y: -offset)
      .shadow(
        color: .white, radius: radius, x: offset, y: offset)
  }
}
