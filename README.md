# Tutor Language

Adaptive offline Spanish tutor.

## Project status

Early development.

## Required reading order

Before implementation, read documents in this order:

1. README.md
2. docs/PROJECT_VISION.md
3. docs/PROJECT_CONTRACT.md
4. docs/ARCHITECTURAL_DECISIONS.md
5. docs/ARCHITECTURE.md
6. docs/CURRICULUM_SPEC.md
7. docs/LEARNING_MODEL.md
8. docs/CONTENT_MODEL.md
9. docs/V1_TECHNICAL_SPEC.md
10. docs/V1_IMPLEMENTATION_CONTRACT.md
11. docs/TECH_STACK.md
12. docs/PROJECT_STRUCTURE.md

Development should begin only after these documents have been read.
The documentation is the project's source of truth.

If implementation conflicts with the documentation, the documentation has higher priority.

## Development workflow

Always follow docs/PROJECT_CONTRACT.md.

Architecture decisions are documented in docs/ARCHITECTURAL_DECISIONS.md.

The educational model is documented in docs/LEARNING_MODEL.md.

Never invent architecture that contradicts existing documentation.

If documentation is insufficient, ask for clarification instead of making architectural assumptions.

## Current implementation status

The Flutter application has been bootstrapped.

The project now contains the language-agnostic curriculum model, content loading foundation and deterministic Lesson Generator skeleton.

The educational core may be implemented after reading V1_IMPLEMENTATION_CONTRACT.md.
