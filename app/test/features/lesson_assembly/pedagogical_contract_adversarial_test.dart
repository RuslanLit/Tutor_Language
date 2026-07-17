import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/lesson_assembly/pedagogical_contract_adversarial_cases.dart';
import 'package:tutor_language/features/lesson_assembly/pedagogical_contract_validator.dart';

void main() {
  const validator = PedagogicalContractValidator();

  for (final adversarialCase in pedagogicalAdversarialCases()) {
    test('${adversarialCase.id} rejects with typed blocker diagnostics', () {
      final issues = adversarialCase.runInvalid(validator);
      final codes = issues.map((issue) => issue.code).toSet();

      expect(codes, containsAll(adversarialCase.expectedCodes));
      for (final code in adversarialCase.expectedCodes) {
        final matching = issues.where((issue) => issue.code == code);
        expect(matching, isNotEmpty, reason: adversarialCase.id);
        expect(
          matching.every(
            (issue) => issue.severity == PedagogicalIssueSeverity.blocker,
          ),
          isTrue,
          reason: '$code in ${adversarialCase.id}',
        );
      }
      expect(
        issues.every((issue) => issue.code.trim().isNotEmpty),
        isTrue,
        reason: adversarialCase.id,
      );
    });

    test('${adversarialCase.id} valid nearest-neighbor control passes', () {
      final issues = adversarialCase.runValidControl(validator);

      expect(issues, isEmpty, reason: adversarialCase.id);
    });
  }
}
