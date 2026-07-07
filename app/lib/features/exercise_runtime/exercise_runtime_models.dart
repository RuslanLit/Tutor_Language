import '../../core/content/topic_content.dart';
import 'answer_check_models.dart';

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
          answerOptions: template.answerOptions
              .map(
                (option) => ExerciseAnswer(id: option.id, label: option.label),
              )
              .toList(growable: false),
          expectedAnswerId: template.correctOptionId,
          expectedTextAnswer: template.expectedAnswer,
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
    this.expectedAnswerId,
    this.expectedTextAnswer,
  });

  final String id;
  final String templateId;
  final String interactionType;
  final String prompt;
  final List<ExerciseAnswer> answerOptions;
  final String? expectedAnswerId;
  final String? expectedTextAnswer;
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

enum ExerciseRuntimeEventType { answerSelected, answerChecked }

class ExerciseRuntimeEvent {
  const ExerciseRuntimeEvent({
    required this.eventType,
    required this.itemId,
    required this.templateId,
    required this.interactionType,
    this.sectionId,
    this.contentReference,
    this.metadataJson,
    this.answerCheckStatus,
  });

  final ExerciseRuntimeEventType eventType;
  final String itemId;
  final String templateId;
  final String interactionType;
  final String? sectionId;
  final String? contentReference;
  final String? metadataJson;
  final AnswerCheckStatus? answerCheckStatus;

  ExerciseRuntimeEvent withContext({
    required String sectionId,
    required String contentReference,
    String? metadataJson,
  }) {
    return ExerciseRuntimeEvent(
      eventType: eventType,
      itemId: itemId,
      templateId: templateId,
      interactionType: interactionType,
      sectionId: sectionId,
      contentReference: contentReference,
      metadataJson: metadataJson,
      answerCheckStatus: answerCheckStatus,
    );
  }
}
