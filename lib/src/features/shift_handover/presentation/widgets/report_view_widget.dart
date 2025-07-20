import '../../../../base/screens/exports.dart';
import '../../domain/entities/shift_report.dart';
import 'input_section.dart';
import 'note_card.dart';

final class ReportViewWidget extends StatelessWidget {
  const ReportViewWidget(this.report, {super.key});

  final ShiftReport report;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      (report.notes.isEmpty)
          ? Text(
              'No notes added yet.\nUse the form below to add the first note.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ).center().expanded()
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: report.notes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => NoteCard(note: report.notes[index]),
            ).expanded(),
      InputSection(),
    ],
  );
}
