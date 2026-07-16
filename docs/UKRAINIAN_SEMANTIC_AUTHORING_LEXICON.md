# Ukrainian Semantic Authoring Lexicon

Status: Clean seed, R2E5R.

This lexicon is for future authored Ukrainian SemanticLocalizationUnit work.
It is not a global replacement dictionary and must not be used for automatic
word-by-word translation.

## Rules

- Author from the semantic unit context, not from legacy Ukrainian strings.
- Preserve Spanish target spans exactly when they are marked protected.
- Keep pronunciation hints separate from meanings.
- Set `review.uk` to `generated` for scaffolds and drafts.
- Set `review.uk` to `approved` only after explicit semantic and language
  review.
- Do not copy Russian wording into Ukrainian.
- Do not use slash morphology such as `потрібен/потрібна` in production text.

## Approved Seed Terms

| Concept | Ukrainian | Scope |
| --- | --- | --- |
| Spanish language | іспанська мова | UI/reporting prose only |
| English source fallback | англійський вихідний текст | Reset diagnostics |
| Semantic unit | семантична одиниця | Authoring documentation |
| Protected span | захищений фрагмент | Authoring documentation |

No legacy educational phrases are approved by this document.
