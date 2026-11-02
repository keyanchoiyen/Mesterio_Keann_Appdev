# Mesterio_Keann_Appdev# CAMPUS LOST & FOUND — FLUTTER PROJECT

## 1. PROJECT IDENTITY

Project Name: Campus Lost & Found  
Platform: Android  
Framework: Flutter  
Programming Language: Dart  
Database: SQLite  
Storage: Local Device Storage  
Tagline: Find it. Return it.

This is a complete rebuild of my previous Campus Lost & Found application. The previous application was developed using Kotlin, but this new version MUST be developed entirely using Flutter and Dart.

The purpose, features, screen layouts, color palette, visual identity, and overall user experience of the previous application must be preserved.

This is not a redesign. This is a rebuild using a different technology.

## 2. MOST IMPORTANT REQUIREMENT: DESIGN PRESERVATION

The existing design reference images inside the `design_reference/` folder are the PRIMARY visual reference.

You MUST inspect and follow these images before implementing any screen.

Do not invent a new design.
Do not randomly change the color palette.
Do not replace the established layout with a generic Flutter template.
Do not remove existing design elements.
Do not change the navigation structure without approval.

Reproduce the reference design as closely as reasonably possible using Flutter widgets.

Preserve:
- The orange and yellow color identity.
- The warm cream background.
- Rounded white cards.
- Button shapes and colors.
- Typography hierarchy.
- Spacing and alignment.
- Icons and visual labels.
- Screen structure and navigation.
- The original Campus Lost & Found branding.
- The tagline "Find it. Return it."

If a design detail is unclear, inspect the reference image again instead of making an unnecessary design change.

Before coding each screen, compare the planned layout with its corresponding reference image.

After implementation, compare the actual screen with the reference and correct visible differences.

## 3. DESIGN SYSTEM

Use these exact color values:

| Color | Hex |
|---|---|
| Primary Orange | #F57C00 |
| Dark Orange | #E86A00 |
| Yellow | #FFC247 |
| Light Yellow | #FFF0CC |
| Background | #FFF9EF |
| White | #FFFFFF |
| Dark Text | #332211 |

Design requirements:

- Use Material 3.
- Use the specified color palette consistently.
- Use rounded cards and buttons.
- Use clean and readable typography.
- Maintain consistent margins and padding.
- Use simple, appropriate icons.
- Keep the design friendly and professional.
- Support different Android screen sizes.
- Avoid unnecessary animations and visual effects.
- Do not introduce unrelated colors.

Create a centralized theme file so colors, text styles, and common component styles remain consistent.

## 4. APPLICATION FEATURES

### A. Splash Screen
- Display the application branding.
- Display the name Campus Lost & Found.
- Display the tagline "Find it. Return it."
- Follow the reference design.

### B. Home Screen
- Display the application name and tagline.
- Display total lost items.
- Display total found items.
- Display recently reported items.
- Provide quick actions for reporting lost or found items.
- Preserve the reference layout.

### C. Report Item Screen
Provide these fields:

- Item Name
- Description
- Location
- Date
- Type: Lost or Found
- Optional Item Photo

Include Save and Cancel buttons.

Validate required fields before saving.

### D. Item List
- Display reported items.
- Show item name, type, date, location, and status.
- Use clear Lost and Found labels.
- Allow users to open item details.

### E. Item Details
Display:
- Item name
- Description
- Location
- Date
- Type
- Photo, if available
- Status

Include Edit, Delete, and Update Status actions.

### F. Search Screen
- Search items by name.
- Filter by Lost or Found.
- Filter by status.
- Display a friendly empty state when no results match.

### G. My Reports
- Display reports stored on the device.
- Allow editing and deleting reports.
- Allow status updates.

### H. Status
Use these statuses:
- Pending
- Claimed
- Returned

### I. Settings
Include:
- About Application
- Application Information
- Developer Information

## 5. NAVIGATION

Use the same navigation structure throughout the application.

Bottom navigation:

1. Home
2. Search
3. Add Item
4. My Reports
5. Settings

The Add Item action must be easy to access.

Do not change the navigation arrangement without approval.

## 6. TECHNOLOGY AND STORAGE

Use:
- Flutter
- Dart
- SQLite through `sqflite`
- `path`
- `path_provider`
- `image_picker`

All records must be saved locally.

Photos must be copied into the application's local documents directory. Save their local file paths in SQLite.

Do not use:
- Firebase
- Online databases
- Cloud storage
- Online authentication
- Kotlin or Java for the application interface

No internet connection should be required for normal application functions.

## 7. DATABASE STRUCTURE

Create an `items` table.

Fields:

- id: INTEGER PRIMARY KEY AUTOINCREMENT
- itemName: TEXT NOT NULL
- description: TEXT NOT NULL
- location: TEXT NOT NULL
- date: TEXT NOT NULL
- type: TEXT NOT NULL
- imagePath: TEXT
- status: TEXT NOT NULL

Implement database functions for:
- Insert item
- Retrieve all items
- Retrieve item by ID
- Update item
- Delete item
- Search items
- Filter items

Use proper database error handling.

## 8. PROJECT STRUCTURE

Use a clean and beginner-friendly structure:

```text
lib/
├── main.dart
├── models/
│   └── item.dart
├── database/
│   └── database_helper.dart
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── add_item_screen.dart
│   ├── item_details_screen.dart
│   ├── search_screen.dart
│   ├── my_reports_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── item_card.dart
│   └── custom_button.dart
└── theme/
    └── app_theme.dart

assets/
├── images/
└── icons/

design_reference/
```

Do not place the entire application inside `main.dart`.

## 9. DEVELOPMENT RULES

- Work phase by phase.
- Follow the reference images.
- Keep the existing design consistent.
- Use reusable widgets.
- Use clear and beginner-friendly Dart code.
- Avoid unnecessary packages.
- Do not generate placeholder screens and claim that the features are complete.
- Do not remove working features when implementing new ones.
- Check for errors after every phase.
- Explain every important file created or modified.
- Do not proceed to the next phase without approval.

## 10. DEVELOPMENT PHASES

Phase 1: Project Inspection and Setup
- Inspect the project and design references.
- Configure Flutter.
- Install packages.
- Create the project structure.
- Set up the design system.

Phase 2: UI Rebuilding
- Build every screen using the reference images.
- Implement bottom navigation.
- Match colors, spacing, cards, buttons, and layouts.
- Use temporary sample data.
- Compare each screen with its reference.

Phase 3: Database
- Implement SQLite.
- Create the item model.
- Implement database initialization.
- Verify local data storage.

Phase 4: Functionality
- Add items.
- Display items.
- Edit items.
- Delete items.
- Search and filter.
- Update statuses.
- Select and store photos locally.

Phase 5: Testing and Finalization
- Test all features.
- Verify persistence after restarting the app.
- Fix UI and functionality issues.
- Run Flutter analysis.
- Build the debug APK.
- Explain how to install and test the application.

## 11. FINAL ACCEPTANCE REQUIREMENTS

The project is complete only when:

1. All required screens are implemented.
2. The original orange/yellow design identity is preserved.
3. Screen layouts closely follow the supplied design references.
4. Bottom navigation works.
5. SQLite operations work correctly.
6. Search and filters work.
7. Edit and delete work.
8. Status updates work.
9. Optional photos are stored locally.
10. Data remains available after restarting the application.
11. The application runs on a physical Android phone.
12. `flutter analyze` has no unresolved errors.
13. The debug APK builds successfully.

Do not claim a feature is working unless it has been implemented and tested.