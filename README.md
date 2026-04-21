# Project 6 - *TranslateMe*

Submitted by: **Gorakh Khatri**

**TranslateMe** is an app that translates words, phrases, or sentences from English to Spanish and stores a history of all past translations using Firebase Firestore. Users can view their saved translations on a separate screen and clear the history at any time.

Time spent: **10** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] Users open the app to a TranslationMe home page with a place to enter a word, phrase or sentence, a button to translate, and another field that should initially be empty
- [x] When users tap translate, the word written in the upper field translates in the lower field. The requirement is only that you can translate from one language to another.
- [x] A history of translations can be stored (in a scroll view in the same screen, or a new screen)
- [x] The history of translations can be erased
 

The following **additional** features are implemented:

- [x] Real-time syncing of translation history via Firestore snapshot listener
- [x] Loading indicator shown on the translate button while a request is in flight
- [x] Input validation disables the translate button when the field is empty

## Video Walkthrough

Here's a walkthrough of implemented user stories:


## Notes

Describe any challenges encountered while building the app.

- Configuring the Firebase Swift Package Manager dependency inside Xcode required linking the `FirebaseCore` and `FirebaseFirestore` products manually to the app target before the imports resolved.
- Ensuring the `GoogleService-Info.plist` was added to the correct target (rather than just copied into the folder) so that `FirebaseApp.configure()` could find it at launch.
- Designing the Firestore data model so each document stored the source text, translated text, source language, target language, and a creation timestamp for correct ordering.

## License

    Copyright 2026 Gorakh Khatri

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
