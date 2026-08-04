import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/activity_engine/activity_engine.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/answer_evaluation/answer_evaluation.dart';

void main() {
  test(
    'structured production is opt-in and accepts communicative punctuation variation',
    () {
      final result = const ActivityEngine().evaluate(
        template: _structuredTemplate,
        submission: const ActivitySubmission(
          submittedAnswer:
              'Hola! Me llamo Marta. ¿Cómo te llamas? Me llamo Ana. Mucho gusto. Hasta luego!',
        ),
      );

      expect(result.isCorrect, isTrue);
      expect(result.status, ActivityResultStatus.acceptedWithFeedback);
      expect(
        result.evaluation?.matchType,
        AnswerMatchType.structuredProductionWithFeedback,
      );
    },
  );

  test('requires_exact_answer takes precedence over structured production', () {
    final result = const ActivityEngine().evaluate(
      template: _exactStructuredTemplate,
      submission: const ActivitySubmission(
        submittedAnswer:
            'Hola! Me llamo Marta. ¿Cómo te llamas? Me llamo Ana. Mucho gusto. Hasta luego!',
      ),
    );

    expect(result.isCorrect, isFalse);
    expect(result.status, ActivityResultStatus.incorrect);
  });
}

const _contract = ProductionContract(
  mode: 'ordered_functions',
  functions: [
    ProductionFunction(
      id: 'greeting',
      required: true,
      acceptedRealizations: ['Hola'],
    ),
    ProductionFunction(
      id: 'self_introduction',
      required: true,
      acceptedRealizations: ['Me llamo Marta.'],
    ),
    ProductionFunction(
      id: 'ask_name',
      required: true,
      acceptedRealizations: ['¿Cómo te llamas?'],
    ),
    ProductionFunction(
      id: 'name_response',
      required: true,
      acceptedRealizations: ['Me llamo Ana.'],
    ),
    ProductionFunction(
      id: 'polite_reaction',
      required: true,
      acceptedRealizations: ['Mucho gusto.'],
    ),
    ProductionFunction(
      id: 'farewell',
      required: true,
      acceptedRealizations: ['Hasta luego.'],
    ),
  ],
);

const _structuredTemplate = ExerciseTemplate(
  id: 'structured',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['independent_complete_exchange'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate: 'Write a contact.',
  expectedAnswer:
      'Hola. Me llamo Marta. ¿Cómo te llamas? Me llamo Ana. Mucho gusto. Hasta luego.',
  productionContract: _contract,
);

const _exactStructuredTemplate = ExerciseTemplate(
  id: 'exact-structured',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['independent_complete_exchange'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate: 'Write the exact contact.',
  expectedAnswer:
      'Hola. Me llamo Marta. ¿Cómo te llamas? Me llamo Ana. Mucho gusto. Hasta luego.',
  requiresExactAnswer: true,
  productionContract: _contract,
);
