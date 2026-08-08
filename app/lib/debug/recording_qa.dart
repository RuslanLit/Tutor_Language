import 'package:flutter/foundation.dart';

const recordingQaEnabled =
    kDebugMode && bool.fromEnvironment('AUDIO_RECORDING_QA');
