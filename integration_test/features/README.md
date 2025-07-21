# Integration Tests Architecture 🧪

Cette architecture de tests d'intégration suit une approche modulaire et organisée pour maintenir des tests lisibles, réutilisables et faciles à maintenir.

## 📁 Structure Générale

```
integration_test/
├── base/                        # Robots de base réutilisables
│   └── base_robot.dart         # Fonctionnalités communes
├── common/                      # Actions communes à l'app
│   └── app_robot.dart          # Navigation et actions générales
└── features/                    # Tests organisés par feature
    └── shift_handover/         # Feature shift handover
        ├── main/               # Tests principaux
        ├── parts/              # Steps modulaires 
        ├── robots/             # Robots spécialisés
        └── README.md           # Documentation (ce fichier)
```

## 🎯 Architecture Shift Handover

### Main Tests (`/main`)
Contient le test principal qui orchestre toutes les étapes :
```dart
// e2e_shift_handover_test.dart
testWidgets('Simple workflow: load app, add one note, submit report', (tester) async {
  await step1LoadApp(tester);    // Chargement de l'app
  await step2AddNote(tester);    // Ajouter une note
  await step3VerifyNote(tester); // Vérifier la note
  await step4SubmitReport(tester); // Soumettre le rapport
});
```

### Modular Steps (`/parts`)
Chaque étape du test est dans un fichier séparé pour une meilleure lisibilité :

```
parts/
├── step_1_load_app.dart      # 🚀 Chargement initial de l'app
├── step_2_add_note.dart      # 📝 Ajout d'une note avec type
├── step_3_verify_note.dart   # ✅ Vérification de la note dans la liste
├── step_4_submit_report.dart # 📤 Soumission du rapport final
└── parts.dart               # Exports pour imports faciles
```

#### Step 1: Load App
- Initialise l'environnement de test
- Charge l'application
- Vérifie l'état initial (1 note mockée)

#### Step 2: Add Note  
- Saisie du texte de la note
- Sélection du type via dropdown
- Soumission avec le bouton clavier
- Gestion du dialog de confirmation

#### Step 3: Verify Note
- Rafraîchissement de la ListView
- Recherche de la nouvelle note 
- Vérification du contenu et du type
- Retry logic pour la stabilité

#### Step 4: Submit Report
- Ouverture du dialog final
- Saisie du résumé
- Soumission du rapport complet

### Specialized Robots (`/robots`)

```
robots/
├── shift_handover_robot.dart          # 🤖 Robot principal unifié
├── shift_handover_actions_robot.dart  # 🎬 Actions (saisie, navigation)
├── shift_handover_assertions_robot.dart # ✅ Vérifications et assertions
└── robots.dart                        # Factory et exports
```

#### Actions Robot
```dart
// Actions de saisie et navigation
await actionsRobot.typeNoteText("Note 1 by dexter");
await actionsRobot.selectNoteTypeIncident();
await actionsRobot.submitNoteWithKeyboard();
await actionsRobot.confirmNoteSubmission();
```

#### Assertions Robot  
```dart
// Vérifications et validations
assertionsRobot.expectInitialNoteLoaded();
assertionsRobot.expectNoteInList("Note 1 by dexter", "INCIDENT");
assertionsRobot.expectSubmitDialogOpen();
```

#### Unified Robot
```dart
// Interface simplifiée combinant actions + assertions
final robot = ShiftHandoverRobot(tester: tester);
await robot.addCompleteNote("Ma note", "INCIDENT"); 
robot.expectNoteExists("Ma note");
```

## 🚀 Usage Pattern

### Import Simple
```dart
import '../parts/parts.dart';  // Tous les steps
import '../robots/robots.dart'; // Tous les robots
```

### Test Structure Type
```dart
testWidgets('Mon test lisible', (tester) async {
  // Setup
  await TestRobots.setupEnvironment();
  
  // Steps modulaires - chacun dans son fichier
  await step1LoadApp(tester);
  await step2AddNote(tester); 
  await step3VerifyNote(tester);
  await step4SubmitReport(tester);
  
  // Assertions finales si nécessaire
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
await actions.typeNoteText("Ma note");
await actions.selectNoteType("INCIDENT");
await actions.submitNote();

// Vérifications  
assertions.expectNoteInList("Ma note");
assertions.expectCorrectNoteType("INCIDENT");
```

## ✨ Key Features

### 🔄 Mock Data Dynamique
- **Mode Test** : 1 seule note mockée pour l'initial state
- **Mode Normal** : 5 notes mockées pour usage standard
- Contrôlé par `AppEnvironment.current.isTest`

### 🎯 Targeting Précis
- Utilisation des clés spécifiques plutôt que sélecteurs génériques
- `notesList` pour la ListView principale
- `noteTypeDropdown` pour le sélecteur de type
- Clés uniques pour éviter les ambiguïtés

### ⚡ Performance & Stabilité
- Retry logic intégré pour les éléments dynamiques
- Refresh forcé de la ListView avec small scrolls
- Délais optimisés pour les animations UI
- Gestion safe du cycle de vie des controllers

### 🐛 Error Handling
- Handler d'erreurs Flutter pour supprimer le bruit dans les logs
- Try-catch autour des opérations fragiles  
- Fallbacks pour les interactions échouées
- Safe disposal des TextEditingController

## 📋 Best Practices

### ✅ Do's
- **Un fichier par step** - Lisibilité maximale
- **Robots spécialisés** - Séparation actions/assertions  
- **Clés spécifiques** - Pas de sélecteurs génériques
- **Retry logic** - Pour les éléments dynamiques
- **Logging détaillé** - Pour le debugging
- **Safe disposal** - Controllers et resources

### ❌ Don'ts  
- **Pas de logique complexe dans main test** - Utiliser les steps
- **Pas de hardcoded delays** - Utiliser les waiters appropriés
- **Pas de sélecteurs fragiles** - Préférer les clés
- **Pas de robots géants** - Séparer les responsabilités
- **Pas d'assertions dans actions** - Garder la séparation

## 🛠️ Extension Guide

### Ajouter un nouveau step
1. Créer `step_X_my_action.dart` dans `/parts`
2. Exporter dans `parts.dart`
3. Utiliser dans le test principal

### Ajouter un nouveau robot  
1. Créer `my_feature_robot.dart` dans `/robots`
2. Étendre `BaseRobot` ou créer spécialisé
3. Exporter dans `robots.dart`
4. Ajouter au factory si besoin

### Ajouter une nouvelle feature
1. Créer dossier `my_feature/` dans `/features`
2. Reproduire structure : `main/`, `parts/`, `robots/`
3. Adapter les patterns existants
4. Documenter dans README spécifique

---

Cette architecture garantit des tests **maintenables**, **lisibles** et **robustes** ! 🎉 