import '../../../../base/screens/exports.dart';
import '../../domain/entities/note_type.dart';
import '../bloc/shift_handover_bloc.dart';
import '../bloc/shift_handover_events.dart';
import '../bloc/shift_handover_states.dart';
import 'loading_widget.dart';

final class InputSection extends StatefulWidget {
  const InputSection({super.key});

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  final textController = TextEditingController();
  NoteType selectedType = NoteType.observation;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        children: [
          Column(
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Add a new note for the next shift...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<ShiftHandoverBloc>().add(AddNewNote(value, selectedType));
                    textController.clear();
                  }
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<NoteType>(
                    value: selectedType,
                    isExpanded: true,
                    icon: const Icon(Icons.category_outlined),
                    onChanged: (NoteType? newValue) {
                      if (newValue != null) {
                        setState(() => selectedType = newValue);
                      }
                    },
                    items: NoteType.values
                        .map(
                          (NoteType type) => DropdownMenuItem<NoteType>(
                            value: type,
                            child: Text(type.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<ShiftHandoverBloc, ShiftHandoverState>(
            builder: (context, state) {
              final isSubmitting = state is Submitting;
              return ElevatedButton.icon(
                icon: isSubmitting ? const SizedBox.shrink() : const Icon(Icons.send),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                onPressed: isSubmitting ? null : () => _showSubmitDialog(context),
                label: isSubmitting
                    ? const SizedBox(height: 24, width: 24, child: LoadingWidget())
                    : const Text('Submit Final Report'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final summaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Finalize and Submit Report', style: AppStyles.headline2.primary()),
        titlePadding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
        content: TextField(
          controller: summaryController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Enter a brief shift summary..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: AppStyles.headline4.secondary()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ShiftHandoverBloc>().add(SubmitReport(summaryController.text));
              Navigator.pop(dialogContext);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ).then((_) => summaryController.dispose());
  }
}
