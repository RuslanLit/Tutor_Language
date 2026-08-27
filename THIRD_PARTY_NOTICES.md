# Third-party notices

Tutor Language is distributed under GPL-3.0-or-later for its original source
code and original project content. The assets below retain their own
provenance and licensing terms.

## Spanish reference audio

The bundled Spanish reference WAV files in
`app/assets/languages/spanish/audio/reference/` are **Generated Output of the
Google Cloud Text-to-Speech API**. They were synthesized at authoring time,
outside the application; no Google SDK, model, API key, or network call is a
runtime dependency of the Android application, and nothing Google-side is
bundled in the APK.

- Voice: `es-ES-Chirp3-HD-Charon` (Spanish (Spain), male, Chirp 3: HD tier),
  24 kHz LINEAR16 output, resampled to 22.05 kHz mono for the bundle. Peak
  normalized to −3 dBFS and leading silence trimmed; no other processing.
- Generated: 2026-08-27.
- Terms in effect: Google Cloud Platform Terms of Service and the Google Cloud
  Service Specific Terms, **"Generative AI Services"** section.
  - <https://cloud.google.com/terms> (accessed 2026-08-27)
  - <https://cloud.google.com/terms/service-terms> (accessed 2026-08-27)
  - <https://cloud.google.com/text-to-speech> (accessed 2026-08-27)
- Under those terms the synthesized audio is **Customer Data**: Google states
  it does not acquire rights to Customer Data or to new intellectual property
  in Generated Output, and permits use of Generated Output (including
  commercial use and redistribution) subject to the Acceptable Use Policy.
  Google, not the customer, is responsible for the training data behind its
  voice models.
- The exact synthesis parameters, per-file SHA-256, and the review record are
  kept with the release engineering notes, not in the APK.

A dated copy of the applicable Terms should be retained with the release
records before each public distribution, and the "Generative AI" section
re-checked for any attribution or non-endorsement clause relevant to store
metadata.

### Archived audio-provenance research (no longer used in production)

Earlier development used Piper `es_ES-sharvard-medium` for this WAV set, and
`es_ES-davefx-medium`, `es_ES-carlfm-*` (incl. the community retrain
`friyin/vits-piper-es_ES-carlfm-high`), `es_ES-mls_*`, and eSpeak NG were
investigated as alternatives. Those voices are **no longer used in
production**. The blocking issue in each case was that redistribution and
commercial-use rights in the *generated recordings* could not be established
from an authoritative source (Sharvard: DataShare record does not display the
CC BY 3.0 grant asserted by the model card; davefx: Lessac Blizzard 2013
lineage restricts use to research; carlfm: LibriVox single-speaker source is
undocumented and its download is gone; mls: broken output). The full
investigation history remains in the Git log for transparency; the current
production voice is Google Cloud Text-to-Speech as described above.

## Font

The bundled Kurale font is distributed under the SIL Open Font License 1.1.
The license text is retained at
`app/assets/fonts/kurale/OFL.txt`.

## Other assets

Project Android icons, splash artwork, lesson text, and application code were
audited as original project assets unless a more specific license is attached
to the asset. No unknown third-party image or model asset is intentionally
bundled. Any future third-party asset must retain its license and be added to
this document before distribution.
