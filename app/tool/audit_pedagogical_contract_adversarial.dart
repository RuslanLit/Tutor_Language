import 'dart:io';

import 'package:tutor_language/features/lesson_assembly/pedagogical_contract_adversarial_cases.dart';
import 'package:tutor_language/features/lesson_assembly/pedagogical_contract_validator.dart';

void main() {
  const validator = PedagogicalContractValidator();
  final cases = pedagogicalAdversarialCases();
  var expectedBlockersObserved = 0;
  var unexpectedPasses = 0;
  var unexpectedDiagnostics = 0;
  var falsePositives = 0;
  final failures = <String>[];

  for (final adversarialCase in cases) {
    final invalidIssues = adversarialCase.runInvalid(validator);
    final invalidCodes = invalidIssues.map((issue) => issue.code).toSet();
    final missing = adversarialCase.expectedCodes.difference(invalidCodes);
    final unexpected = invalidCodes.difference(adversarialCase.expectedCodes);

    if (invalidIssues.isEmpty || missing.isNotEmpty) {
      unexpectedPasses += 1;
      failures.add(
        '${adversarialCase.id}: missing expected diagnostics ${missing.join(', ')}',
      );
    }
    if (unexpected.isNotEmpty) {
      unexpectedDiagnostics += unexpected.length;
      failures.add(
        '${adversarialCase.id}: unexpected diagnostics ${unexpected.join(', ')}',
      );
    }
    for (final code in adversarialCase.expectedCodes) {
      final matching = invalidIssues.where((issue) => issue.code == code);
      expectedBlockersObserved += matching
          .where((issue) => issue.severity == PedagogicalIssueSeverity.blocker)
          .length;
      if (matching.any(
        (issue) => issue.severity != PedagogicalIssueSeverity.blocker,
      )) {
        failures.add('${adversarialCase.id}: $code was not blocker severity');
      }
    }

    final validControlIssues = adversarialCase.runValidControl(validator);
    if (validControlIssues.isNotEmpty) {
      falsePositives += 1;
      failures.add(
        '${adversarialCase.id}: valid control failed with ${validControlIssues.map((issue) => issue.code).join(', ')}',
      );
    }
  }

  final pass = failures.isEmpty;
  stdout.writeln(pass ? 'PASS' : 'FAIL');
  stdout.writeln('Adversarial cases executed: ${cases.length}');
  stdout.writeln('Expected blockers observed: $expectedBlockersObserved');
  stdout.writeln('Unexpected passes: $unexpectedPasses');
  stdout.writeln('Unexpected diagnostics: $unexpectedDiagnostics');
  stdout.writeln('False positives: $falsePositives');

  if (!pass) {
    for (final failure in failures) {
      stdout.writeln('  $failure');
    }
    exitCode = 1;
  }
}
