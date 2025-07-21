import 'package:intl/intl.dart';

import '../../../../base/screens/exports.dart';
import '../../domain/entities/handover_note.dart';
import '../../domain/entities/note_type.dart';

@visibleForTesting
enum NoteCardKeys { noteIcon, noteText, noteTypeText, noteTimestampText }

final class NoteCard extends StatelessWidget {
  final HandoverNote note;

  const NoteCard({super.key, required this.note});

  static const Map<NoteType, IconData> _iconMap = {
    NoteType.observation: Icons.visibility_outlined,
    NoteType.incident: Icons.warning_amber_rounded,
    NoteType.medication: Icons.medical_services_outlined,
    NoteType.task: Icons.check_circle_outline,
    NoteType.supplyRequest: Icons.shopping_cart_checkout_outlined,
  };

  static final Map<NoteType, Color> _colorMap = {
    NoteType.observation: Colors.blue.shade700,
    NoteType.incident: Colors.red.shade700,
    NoteType.medication: Colors.purple.shade700,
    NoteType.task: Colors.green.shade700,
    NoteType.supplyRequest: Colors.orange.shade700,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colorMap[note.type] ?? Colors.grey;
    final icon = _iconMap[note.type] ?? Icons.help_outline;

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            key: NoteCardKeys.noteIcon.key,
            padding: const EdgeInsets.only(right: 12.0, top: 4.0),
            child: Icon(icon, color: color, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                key: NoteCardKeys.noteText.key,
                note.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      key: NoteCardKeys.noteTypeText.key,
                      note.type.name.toUpperCase(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    key: NoteCardKeys.noteTimestampText.key,
                    DateFormat.jm().format(note.timestamp),
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ).expanded(),
        ],
      ).overallPadding(12),
    );
  }
}
