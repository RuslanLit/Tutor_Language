import 'dart:convert';
import 'dart:io';

import 'spanish_a0_pronunciation_inventory_support.dart';

void main() {
  final appDirectory = Directory.current;
  if (!Directory(
    '${appDirectory.path}/assets/languages/spanish',
  ).existsSync()) {
    stderr.writeln('Run from app/.');
    exitCode = 1;
    return;
  }

  final inventory = buildSpanishA0PronunciationInventory(
    appDirectory: appDirectory,
  );
  final reportDirectory = Directory('${appDirectory.path}/build/reports');
  reportDirectory.createSync(recursive: true);
  File(
    '${reportDirectory.path}/spanish_a0_pronunciation_inventory.json',
  ).writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(inventory.toJson()),
  );
  File(
    '../docs/SPANISH_A0_PRONUNCIATION_INVENTORY.md',
  ).writeAsStringSync(inventoryMarkdown(inventory));

  stdout.writeln('Spanish A0 pronunciation inventory');
  stdout.writeln('lessonsAudited=${inventory.lessonsAudited}');
  stdout.writeln('learnerFacingForms=${inventory.totalItems}');
  stdout.writeln('coveredForms=${inventory.coveredItems}');
  stdout.writeln('missingForms=${inventory.missingItems}');
  stdout.writeln('uniqueForms=${inventory.uniqueForms}');
  stdout.writeln('missingUniqueForms=${inventory.missingUniqueForms}');
  stdout.writeln(
    'jsonReport=build/reports/spanish_a0_pronunciation_inventory.json',
  );
  stdout.writeln(
    'markdownReport=../docs/SPANISH_A0_PRONUNCIATION_INVENTORY.md',
  );

  if (!inventory.isComplete) {
    exitCode = 1;
  }
}
