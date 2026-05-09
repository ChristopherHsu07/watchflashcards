//
//  ContentView.swift
//  watchflashcards
//
//  Created by Christopher Hsu on 4/24/26.
//
// source control test

import SwiftUI

struct Flashcard: Identifiable {
    let id = UUID()
    let front: String
    let back: String
}

struct FlashcardSet: Identifiable {
    let id = UUID()
    let title: String
    let cardCount: Int
    let description: String
    let cards: [Flashcard]
}

struct ContentView: View {
    @State private var flashcardSets: [FlashcardSet] = [
        FlashcardSet(
            title: "Sample Set Test",
            cardCount: 5,
            description: "A starter set to confirm the home list is working.",
            cards: []
        ),
        FlashcardSet(
            title: "Spanish Basics",
            cardCount: 18,
            description: "Core vocabulary for everyday phrases.",
            cards: []
        ),
        FlashcardSet(
            title: "US History Dates",
            cardCount: 12,
            description: "Important events and years to memorize.",
            cards: []
        )
    ]

    @State private var isManagingSets = false
    @State private var isShowingCreateView = false

    var body: some View {
        NavigationStack {
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
                            HStack(alignment: .center, spacing: 12) {
                                if isManagingSets {
                                    Button("Edit") {
                                        // Card editing — coming later
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                }

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

                                if isManagingSets {
                                    Button(role: .destructive) {
                                        flashcardSets.removeAll { $0.id == set.id }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                }
                            }
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
                    .animation(.default, value: flashcardSets.map(\.id))

                    Spacer(minLength: 8)

                    Button("Create") {
                        isShowingCreateView = true
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if isManagingSets {
                        Button("Done") {
                            isManagingSets = false
                        }
                    } else {
                        Button("Edit") {
                            isManagingSets = true
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingCreateView) {
                CreateFlashcardSetView { newSet in
                    flashcardSets.append(newSet)
                }
            }
        }
    }
}

private struct DraftFlashcard: Identifiable {
    let id = UUID()
    var front = ""
    var back = ""
}

struct CreateFlashcardSetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var setTitle = ""
    @State private var draftCards: [DraftFlashcard] = [DraftFlashcard()]

    let onSave: (FlashcardSet) -> Void

    private var canSave: Bool {
        let hasTitle = !setTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let validCardCount = draftCards.filter { card in
            !card.front.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !card.back.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }.count
        return hasTitle && validCardCount > 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Set title", text: $setTitle)
                        .font(.title2)
                        .textFieldStyle(.roundedBorder)

                    ForEach($draftCards) { $card in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Front", text: $card.front)
                                .textFieldStyle(.roundedBorder)
                            TextField("Back", text: $card.back)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }

                    Button("Add Card") {
                        draftCards.append(DraftFlashcard())
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Create Set")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                Button("Done") {
                    let cardsToSave = draftCards.compactMap { draft -> Flashcard? in
                        let front = draft.front.trimmingCharacters(in: .whitespacesAndNewlines)
                        let back = draft.back.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !front.isEmpty && !back.isEmpty else { return nil }
                        return Flashcard(front: front, back: back)
                    }

                    let cleanedTitle = setTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                    let newSet = FlashcardSet(
                        title: cleanedTitle,
                        cardCount: cardsToSave.count,
                        description: "Custom set created by you.",
                        cards: cardsToSave
                    )

                    onSave(newSet)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    ContentView()
}
