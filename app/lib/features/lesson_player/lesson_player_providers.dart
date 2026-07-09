import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lesson_assembly/lesson_assembly_service.dart';
import '../lesson_assembly/lesson_content.dart';

final lessonAssemblyServiceProvider = Provider<LessonAssemblyService>((ref) {
  return LessonAssemblyService();
});

final assembledLessonProvider = FutureProvider.family<LessonContent, String>((
  ref,
  lessonId,
) {
  return ref.watch(lessonAssemblyServiceProvider).assembleLesson(lessonId);
});
