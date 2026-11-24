# CampusConnect Architecture

```text
                         Flutter UI
                             |
        +--------------------+--------------------+
        |                    |                    |
  HomeShellScreen       SettingsScreen      API / Cloud screens
  TabBar + TabBarView   Theme + clear data  FutureBuilder / StreamBuilder
        |                    |                    |
        +--------------------+--------------------+
                             |
                       Provider layer
                 +-----------+-----------+
                 |           |           |
            EventProvider NoteProvider ThemeProvider
                 |           |           |
       +---------+           |           +-- SharedPreferences
       |                     |
       |              LocalStorageService
       |                     |
       |              JSON notes file
       |
  +----+-----------------------------+
  |                                  |
MockEventService               FirestoreService
  |                                  |
Sample event data              Cloud Firestore
                                   |
                         Shared real-time events
```

## Data responsibilities

- **EventProvider:** event list, category selection, RSVP state, optimistic event creation, Firestore stream subscription, and rollback on rejected operations.
- **NoteProvider:** in-memory note state and persistence through `LocalStorageService`.
- **ThemeProvider:** light/dark/system preference.
- **LocaleProvider:** selected language.
- **LocalStorageService:** notes JSON file and RSVP IDs in SharedPreferences.
- **FirestoreService:** shared event documents and real-time snapshots.
- **PublicEventApiService:** fetches demonstration posts from JSONPlaceholder and maps JSON into `PublicEvent` objects.

## Firestore event document (suggested shape)

```json
{
  "title": "Coding Competition",
  "description": "Campus coding contest",
  "category": "Technology",
  "location": "Seminar Hall",
  "createdAt": "Firestore Timestamp",
  "updatedAt": "Firestore Timestamp",
  "attendees": ["authenticated-user-id"]
}
```

For a production app, use Firebase Authentication UIDs instead of the current demonstration identity and validate writes with Firestore security rules.
