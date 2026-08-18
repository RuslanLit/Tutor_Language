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

  test('reports missing multiline dialogue lines', () {
    final result = evaluator.evaluate(
      learnerAnswer: 'Hola.\nMe llamo Marta.',
      canonicalAnswer: _diagnosticCanonical,
      contract: _diagnosticContract,
    );

    expect(result.status, AnswerEvaluationStatus.incorrect);
    expect(result.feedback.structure?.submittedLineCount, 2);
    expect(result.feedback.structure?.expectedLineCount, 4);
    expect(result.feedback.structure?.missingLineCount, 2);
  });

  test('reports the specific incorrect multiline dialogue line', () {
    final result = evaluator.evaluate(
      learnerAnswer:
          'Hola.\nMe llamo Marta.\n¿Cómo te llamas?\nMe llamo Luis.',
      canonicalAnswer: _diagnosticCanonical,
      contract: _diagnosticContract,
    );

    expect(result.status, AnswerEvaluationStatus.incorrect);
    expect(result.feedback.structure?.correctLineNumbers, [1, 2, 3]);
    expect(result.feedback.structure?.incorrectLineNumbers, [4]);
  });

  test('accepts a complete multiline dialogue', () {
    final result = evaluator.evaluate(
      learnerAnswer: _diagnosticCanonical,
      canonicalAnswer: _diagnosticCanonical,
      contract: _diagnosticContract,
    );

    expect(result.isAccepted, isTrue);
  });

  test('keeps ñ and ü distinct from n and u', () {
    const enyeContract = ProductionContract(
      mode: 'ordered_functions',
      functions: [
        ProductionFunction(
          id: 'name',
          required: true,
          acceptedRealizations: ['El niño vive aquí.'],
        ),
      ],
    );
    const umlautContract = ProductionContract(
      mode: 'ordered_functions',
      functions: [
        ProductionFunction(
          id: 'animal',
          required: true,
          acceptedRealizations: ['El pingüino canta.'],
        ),
      ],
    );

    final enye = evaluator.evaluate(
      learnerAnswer: 'El nino vive aquí.',
      canonicalAnswer: 'El niño vive aquí.',
      contract: enyeContract,
    );
    final umlaut = evaluator.evaluate(
      learnerAnswer: 'El pinguino canta.',
      canonicalAnswer: 'El pingüino canta.',
      contract: umlautContract,
    );

    expect(enye.status, AnswerEvaluationStatus.incorrect);
    expect(umlaut.status, AnswerEvaluationStatus.incorrect);
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

const _diagnosticCanonical =
    'Hola.\nMe llamo Marta.\n¿Cómo te llamas?\nMe llamo Ana.';

const _diagnosticContract = ProductionContract(
  mode: 'ordered_functions',
  functions: [
    ProductionFunction(
      id: 'greeting',
      required: true,
      acceptedRealizations: ['Hola.'],
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
  ],
);
