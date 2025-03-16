//
//  ItemEditView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 16.03.25.
//

import SwiftUI

struct ItemEditView: View {
    let item: WardrobeItem
    let isEditing: Bool
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            WardrobeItemCard(item: item)
                .overlay(
                    isEditing
                        ? Color.black.opacity(0.6)
                            .animation(.easeInOut(duration: 0.3))
                            .cornerRadius(10)
                        : nil
                )
                .allowsHitTesting(!isEditing)

            if isEditing {
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.red)
                        .scaleEffect(isEditing ? 1.0 : 0.5)
                        .opacity(isEditing ? 1 : 0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isEditing)
                }
                .position(x: 70, y: 70)
            }
        }
    }
}
