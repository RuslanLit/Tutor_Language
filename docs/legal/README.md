# Legal archive — reference-audio licensing basis

Dated copies of the third-party terms that `THIRD_PARTY_NOTICES.md` (repo root,
section **"Spanish reference audio"**) relies on for the bundled Spanish
reference WAV files. Those files are Generated Output of the Google Cloud
Text-to-Speech API (voice `es-ES-Chirp3-HD-Charon`), synthesized at authoring
time in commit `cc1792d`.

Keep one such dated set with the release records for each public distribution,
per the closing note in `THIRD_PARTY_NOTICES.md`.

Only this `README.md` and the plain-text section extract
(`gcp-generative-ai-services-section_2026-08-28.txt`) are tracked in git. The
full `.html` page captures are ~1.5 MB of client-rendered markup and are kept
with the offline release records, not in the repository. The SHA-256 table
below is the integrity anchor for those retained copies.

## Captured 2026-08-28 (UTC), via `curl`

| File | Source URL | Page `Last-Modified` at capture | SHA-256 |
|---|---|---|---|
| `gcp-terms-of-service_2026-08-28.html` | <https://cloud.google.com/terms> | Mon, 22 Jun 2026 14:00:35 GMT | `5e48428fd7fe309c0d2333d5ac96e4cdf826d7378e0ab1d934df64d0b127b48d` |
| `gcp-service-specific-terms_2026-08-28.html` | <https://cloud.google.com/terms/service-terms> | Thu, 30 Jul 2026 13:06:18 GMT | `deaa2dc4114ff09b55144d3091826bbb0d63ffc8fb51d91c3f405050c48ee999` |
| `gcp-acceptable-use-policy_2026-08-28.html` | <https://cloud.google.com/terms/aup> | (not sent) | `3f26372747acbedf42f3c5822373acbe1ea53a5fc8118eeb407d7e26e8139964` |
| `google-generative-ai-prohibited-use-policy_2026-08-28.html` | <https://policies.google.com/terms/generative-ai/use-policy> | (not sent) | `24d98a599fd5ab7bf47fd23df47ff4f330f518316b383cc17407a2d144502d9a` |
| `gcp-generative-ai-services-section_2026-08-28.txt` | — (plain-text extract of the section from the file above) | — | `2e109bea00ccb7927a21950f6c159f6c4064cffacd0d14471944e421e3ed1e44` |

The retained `.html` files are the archival copies as served (client-rendered
pages, so some content loads via script). The tracked `.txt` file is a
convenience extract of the **"Generative AI Services"** section only — numbered **Section 20** in this
capture (the terms note "formerly Section 19"). If the extract and the HTML
disagree, the HTML and the live page govern.

## Section 20 "Generative AI Services" — points the notice depends on

- **(a) Definition.** "Generated Output" is the data/content a Generative AI
  Service produces from Customer Data. **"Generated Output is Customer Data."**
  As between Customer and Google, **Google does not assert ownership rights in
  any new intellectual property created in the Generated Output.**
- **(c) Prohibited Use Policy** for Generative AI Services is
  <https://policies.google.com/terms/generative-ai/use-policy> (incorporated
  into the AUP).
- **(d) Age restriction / (e) Healthcare restriction** — declared "Use
  Restrictions"; not relevant to this app (a general-audience language course,
  no clinical use).
- **(h) Handling of prompts/output** — Google will not store prompts or
  Generated Output outside the customer account beyond what is needed to
  produce the output.

The synthesis itself happened outside the app; no Google SDK, model, API key or
network call is a runtime dependency, and nothing Google-side ships in the APK.
F-Droid metadata declares the `NonFreeAssets` anti-feature for the bundled
speech (proprietary TTS output with no upstream dataset-licensing chain).

## Re-capture procedure

```
cd docs/legal
DATE=$(date -u +%Y-%m-%d)
UA="Mozilla/5.0 (X11; Linux x86_64) archival-copy"
for pair in \
  "https://cloud.google.com/terms|gcp-terms-of-service" \
  "https://cloud.google.com/terms/service-terms|gcp-service-specific-terms" \
  "https://cloud.google.com/terms/aup|gcp-acceptable-use-policy" \
  "https://policies.google.com/terms/generative-ai/use-policy|google-generative-ai-prohibited-use-policy"; do
  url=${pair%%|*}; name=${pair##*|}
  curl -sS -L -A "$UA" "$url" -o "${name}_${DATE}.html"
done
sha256sum *_"$DATE".* 
```
