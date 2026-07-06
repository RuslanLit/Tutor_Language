import '../../core/content/topic_content.dart';

class ExerciseSession {
  const ExerciseSession({required this.id, required this.items});

  factory ExerciseSession.fromTemplate(ExerciseTemplate template) {
    return ExerciseSession(
      id: 'session.${template.id}',
      items: [
        ExerciseItem(
          id: 'item.${template.id}',
          templateId: template.id,
          interactionType: template.exerciseType,
          prompt: template.promptTemplate,
          answerOptions: const [],
        ),
      ],
    );
  }

  final String id;
  final List<ExerciseItem> items;
}

class ExerciseItem {
  const ExerciseItem({
    required this.id,
    required this.templateId,
    required this.interactionType,
    required this.prompt,
    this.answerOptions = const [],
  });

  final String id;
  final String templateId;
  final String interactionType;
  final String prompt;
  final List<ExerciseAnswer> answerOptions;
}

class ExerciseAnswer {
  const ExerciseAnswer({required this.id, required this.label});

  final String id;
  final String label;
}

class ExerciseResponse {
  const ExerciseResponse({
    required this.itemId,
    required this.answer,
    required this.respondedAt,
  });

  final String itemId;
  final ExerciseAnswer answer;
  final DateTime respondedAt;
}

class ExerciseInteractionState {
  const ExerciseInteractionState({this.responses = const {}});

  final Map<String, ExerciseResponse> responses;

  ExerciseResponse? responseFor(String itemId) {
    return responses[itemId];
  }

  ExerciseInteractionState recordResponse(ExerciseResponse response) {
    return ExerciseInteractionState(
      responses: {...responses, response.itemId: response},
    );
  }
}
