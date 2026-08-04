import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/answer_evaluation/answer_evaluation.dart';

void main() {
  const evaluator = StructuredProductionEvaluator();

  test('accepts the canonical Lesson 1 production', () {
    final result = evaluator.evaluate(
      learnerAnswer: _canonical,
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(result.status, AnswerEvaluationStatus.correct);
  });

  test('accepts punctuation variation with feedback', () {
    final result = evaluator.evaluate(
      learnerAnswer: _canonical.replaceFirst('Hola.', 'Hola!'),
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
    expect(result.isAccepted, isTrue);
  });

  test('accepts opening exclamation variation with feedback', () {
    final result = evaluator.evaluate(
      learnerAnswer: _canonical.replaceFirst('Hola.', '¡Hola!'),
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
  });

  test('does not make line breaks semantic', () {
    final result = evaluator.evaluate(
      learnerAnswer: _canonical.replaceFirst(
        'Hola. Buenos días.',
        'Hola.\nBuenos días.',
      ),
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(result.status, AnswerEvaluationStatus.correct);
  });

  test('accepts case and whitespace variation', () {
    final result = evaluator.evaluate(
      learnerAnswer:
          '  HOLA.   BUENOS DÍAS.\nME LLAMO MARTA.\n¿CÓMO TE LLAMAS?\nME LLAMO ANA.\nMUCHO GUSTO.\nHASTA LUEGO.  ',
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(result.status, AnswerEvaluationStatus.correct);
  });

  test('rejects a missing required function', () {
    final result = evaluator.evaluate(
      learnerAnswer: _canonical.replaceFirst('Me llamo Ana.\n', ''),
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(result.status, AnswerEvaluationStatus.incorrect);
  });

  test('rejects a wrong required name and meaningful order', () {
    final wrongName = evaluator.evaluate(
      learnerAnswer: _canonical.replaceFirst(
        'Me llamo Marta.',
        'Me llamo Ana.',
      ),
      canonicalAnswer: _canonical,
      contract: _contract,
    );
    final wrongOrder = evaluator.evaluate(
      learnerAnswer: _canonical.replaceFirst(
        'Mucho gusto.\nHasta luego.',
        'Hasta luego.\nMucho gusto.',
      ),
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(wrongName.status, AnswerEvaluationStatus.incorrect);
    expect(wrongOrder.status, AnswerEvaluationStatus.incorrect);
  });

  test('rejects obsolete expanded profile text', () {
    final result = evaluator.evaluate(
      learnerAnswer: '$_canonical\n¿De dónde eres?\nSoy de España.',
      canonicalAnswer: _canonical,
      contract: _contract,
    );

    expect(result.status, AnswerEvaluationStatus.incorrect);
  });
}

const _canonical =
    'Hola. Buenos días.\nMe llamo Marta.\n¿Cómo te llamas?\nMe llamo Ana.\nMucho gusto.\nHasta luego.';

const _contract = ProductionContract(
  mode: 'ordered_functions',
  functions: [
    ProductionFunction(
      id: 'greeting',
      required: true,
      acceptedRealizations: ['Hola', 'Buenos días', 'Hola. Buenos días.'],
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
