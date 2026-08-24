# Third-party notices

Tutor Language is distributed under GPL-3.0-or-later for its original source
code and original project content. The assets below retain their own
provenance and licensing terms.

## Spanish reference audio

The bundled Spanish reference WAV files in
`app/assets/languages/spanish/audio/reference/` were generated locally during
development with Piper using the voice `es_ES-sharvard-medium`. Piper and its
voice metadata are not runtime dependencies of the Android application, and
the Piper executable, voice model, and development virtual environments are
not bundled in the APK.

The upstream voice record is published in the `rhasspy/piper-voices`
repository:

- Voice/model record: <https://huggingface.co/rhasspy/piper-voices/tree/main/es/es_ES/sharvard/medium>
- Voice model metadata: <https://huggingface.co/rhasspy/piper-voices/blob/main/es/es_ES/sharvard/medium/MODEL_CARD>
- The upstream `piper-voices` repository/model record is marked MIT in its
  published metadata.

The voice model card identifies the training data as the Sharvard corpus
(also referred to as Sharvard_IJA):

- Dataset: Sharvard Corpus
- Authors: Vincent Aubanel; Maria Luisa García Lecumberri; Martin Cooke
- Dataset license identified by the voice model card: Creative Commons
  Attribution 3.0 (CC BY 3.0)
- Dataset source: <https://datashare.ed.ac.uk/handle/10283/574>
- Dataset citation: <https://doi.org/10.3109/14992027.2014.907507>

These notices document the upstream provenance of the voice used to generate
the files. Tutor Language generated the bundled WAV files during development.
They are distributed as project reference audio with the applicable upstream
provenance and attribution preserved. No claim is made that the generated WAV
files are MIT, CC BY 3.0, or relicensed under GPL merely because those terms
apply to upstream components or source data. The remaining release question
is whether any additional attribution or redistribution condition applies to
these generated recordings under the exact voice/model and dataset/depositor
terms; that question must be confirmed before public distribution.

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
