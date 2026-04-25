//
//  ContentView.swift
//  watchflashcards
//
//  Created by Christopher Hsu on 4/24/26.
//
// source control test

import SwiftUI

struct FlashcardSet: Identifiable {
    let id = UUID()
    let title: String
    let cardCount: Int
    let description: String
}

struct ContentView: View {
    private let flashcardSets: [FlashcardSet] = [
        FlashcardSet(
            title: "Sample Set Test",
            cardCount: 5,
            description: "A starter set to confirm the home list is working."
        ),
        FlashcardSet(
            title: "Spanish Basics",
            cardCount: 18,
            description: "Core vocabulary for everyday phrases."
        ),
        FlashcardSet(
            title: "US History Dates",
            cardCount: 12,
            description: "Important events and years to memorize."
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Flashcard Sets")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 8)

                Text("Choose a set to practice soon.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                LazyVStack(spacing: 12) {
                    ForEach(flashcardSets) { set in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(set.title)
                                .font(.headline)
                            Text("\(set.cardCount) cards")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(set.description)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
