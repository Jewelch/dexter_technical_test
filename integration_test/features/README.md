# Integration Tests Architecture 🧪

This integration test architecture follows a modular and organized approach to maintain readable, reusable, and easy-to-maintain tests.

## 📁 General Structure

```
integration_test/
├── base/                        # Reusable base robots
│   └── base_robot.dart         # Common functionalities
├── common/                      # Common app actions
│   └── app_robot.dart          # Navigation and general actions
└── features/                    # Tests organized by feature
    └── shift_handover/         # Shift handover feature
        ├── main/               # Main tests
        ├── parts/              # Modular steps 
        ├── robots/             # Specialized robots
        └── README.md           # Documentation (this file)
```

## 🎯 Shift Handover Architecture

### Main Tests (`/main`)
Contains the main test that orchestrates all steps:
```dart
// e2e_shift_handover_test.dart
testWidgets('Simple workflow: load app, add one note, submit report', (tester) async {
  await step1LoadApp(tester);    // Load the app
  await step2AddNote(tester);    // Add a note
  await step3VerifyNote(tester); // Verify the note
  await step4SubmitReport(tester); // Submit the report
});
```

### Modular Steps (`/parts`)
Each test step is in a separate file for better readability:

```
parts/
├── step_1_load_app.dart      # 🚀 Initial app loading
├── step_2_add_note.dart      # 📝 Adding a note with type
├── step_3_verify_note.dart   # ✅ Verifying note in the list
├── step_4_submit_report.dart # 📤 Final report submission
└── parts.dart               # Exports for easy imports
```

#### Step 1: Load App
- Initializes test environment
- Loads the application
- Verifies initial state (1 mocked note)

#### Step 2: Add Note  
- Input note text
- Select type via dropdown
- Submit with keyboard button
- Handle confirmation dialog

#### Step 3: Verify Note
- Refresh ListView
- Search for the new note 
- Verify content and type
- Retry logic for stability

#### Step 4: Submit Report
- Open final dialog
- Input summary
- Submit complete report

### Specialized Robots (`/robots`)

```
robots/
├── shift_handover_robot.dart          # 🤖 Main unified robot
├── shift_handover_actions_robot.dart  # 🎬 Actions (input, navigation)
├── shift_handover_assertions_robot.dart # ✅ Verifications and assertions
└── robots.dart                        # Factory and exports
```

#### Actions Robot
```dart
// Input and navigation actions
await actionsRobot.typeNoteText("Note 1 by dexter");
await actionsRobot.selectNoteTypeIncident();
await actionsRobot.submitNoteWithKeyboard();
await actionsRobot.confirmNoteSubmission();
```

#### Assertions Robot  
```dart
// Verifications and validations
assertionsRobot.expectInitialNoteLoaded();
assertionsRobot.expectNoteInList("Note 1 by dexter", "INCIDENT");
assertionsRobot.expectSubmitDialogOpen();
```

#### Unified Robot
```dart
// Simplified interface combining actions + assertions
final robot = ShiftHandoverRobot(tester: tester);
await robot.addCompleteNote("My note", "INCIDENT"); 
robot.expectNoteExists("My note");
```

## 🚀 Usage Pattern

### Simple Import
```dart
import '../parts/parts.dart';  // All steps
import '../robots/robots.dart'; // All robots
```

### Test Structure Type
```dart
testWidgets('My readable test', (tester) async {
  // Setup
  await TestRobots.setupEnvironment();
  
  // Modular steps - each in its own file
  await step1LoadApp(tester);
  await step2AddNote(tester); 
  await step3VerifyNote(tester);
  await step4SubmitReport(tester);
  
  // Final assertions if needed
  final robot = ShiftHandoverRobot(tester: tester);
  robot.expectFinalSuccess();
});
```

### Robot Usage Pattern
```dart
// Setup robots
final actions = ShiftHandoverActionsRobot(tester: tester);
final assertions = ShiftHandoverAssertionsRobot(tester: tester);

// Actions
await actions.typeNoteText("My note");
await actions.selectNoteType("INCIDENT");
await actions.submitNote();

// Verifications  
assertions.expectNoteInList("My note");
assertions.expectCorrectNoteType("INCIDENT");
```

## ✨ Key Features

### 🔄 Dynamic Mock Data
- **Test Mode**: Only 1 mocked note for initial state
- **Normal Mode**: 5 mocked notes for standard usage
- Controlled by `AppEnvironment.current.isTest`

### 🎯 Precise Targeting
- Using specific keys rather than generic selectors
- `notesList` for the main ListView
- `noteTypeDropdown` for type selector
- Unique keys to avoid ambiguities

### ⚡ Performance & Stability
- Built-in retry logic for dynamic elements
- Forced ListView refresh with small scrolls
- Optimized delays for UI animations
- Safe lifecycle management for controllers

### 🐛 Error Handling
- Flutter error handler to suppress noise in logs
- Try-catch around fragile operations  
- Fallbacks for failed interactions
- Safe disposal of TextEditingControllers

## 📋 Best Practices

### ✅ Do's
- **One file per step** - Maximum readability
- **Specialized robots** - Separate actions/assertions  
- **Specific keys** - No generic selectors
- **Retry logic** - For dynamic elements
- **Detailed logging** - For debugging
- **Safe disposal** - Controllers and resources

### ❌ Don'ts  
- **No complex logic in main test** - Use steps
- **No hardcoded delays** - Use appropriate waiters
- **No fragile selectors** - Prefer keys
- **No giant robots** - Separate responsibilities
- **No assertions in actions** - Keep separation

## 🛠️ Extension Guide

### Adding a new step
1. Create `step_X_my_action.dart` in `/parts`
2. Export in `parts.dart`
3. Use in main test

### Adding a new robot  
1. Create `my_feature_robot.dart` in `/robots`
2. Extend `BaseRobot` or create specialized
3. Export in `robots.dart`
4. Add to factory if needed

### Adding a new feature
1. Create `my_feature/` folder in `/features`
2. Reproduce structure: `main/`, `parts/`, `robots/`
3. Adapt existing patterns
4. Document in specific README

---

This architecture guarantees **maintainable**, **readable** and **robust** tests! 🎉 