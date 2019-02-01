# 'Bout Time
## *Treehouse iOS Techdegree Project 3*

For this project, you’ll be building an actual game, ‘Bout Time, from the ground up.

Specifically, the game involves users taking historical events and seeing if they can put them in the correct chronological order. A single round of play consists of ordering four random events, and there are six rounds in each full game. You will not only write the code to build the user interface, you’ll also decide what kind of events to quiz the user about. We hope you embrace this aspect of the project and pick a topic you’ll enjoy - it’ll help you stay motivated and be more fun to show off when you’re done.

In terms of overall difficulty, this app is roughly the same as the quiz app you worked on in Project 2, but of course this time you’ll be starting from scratch. Don’t let that scare you. You have most, if not all of of the tools you need to get the job done. That said, don’t be surprised if you need to re-watch video or ask the community for help. Also, we aren’t requiring you to add any audio for the project, but if you’d like to, we’ve provided a few sounds for you to use.

#### Required tasks

- [x] Build the user interface of the app per the provided mockups. Be sure to integrate the app icons provided.
- [x] The app should display correctly on iPhones with screen sizes of 4.7 inches and 5.5 inches
- [x] Create a list of at least 25 historical events (each event should have the event description and the corresponding year, such as “Rio Olympics - 2016”) to be used as the content for the game. If you’d like the game to be playable many times, we suggest a list of at least 40 events, but that is not required.
- [x] Create custom types (structs or classes) to model the events, as well as any other entities you think should be modeled using custom types.
- [x] Create functions to randomly populate the events for each round of play, making sure no event appears twice in the same round of play. Each round should have 4 events. An event may be repeated during a game, just not in an individual round.
- [x] Create UI logic to allow users to re-order the events using the up and down buttons.
    - [x] Note, the labels containing the events should not move, rather, the content will be re-populated when events are moved up and down.
- [x] Create a method to determine whether or not the events were ordered correctly. Points should only be awarded for fully correct solutions. Afterwards, another round of play will then begin. You can choose whether the oldest events should be at the top or at the bottom, depending on your game's content.
- [x] Create a countdown timer to give users 60 seconds to correctly order the events. When the timer expires, the events orders are checked for correctness.
- [x] If a user completes the ordering in less than 60 secsonds, they should be able to shake the device in order to get the order checked immediately.
- [x] Create logic such that after 6 rounds of play the game concludes and a total score is displayed.
- [ ] Before you submit your project for review, make sure you can check off all of the items on the [Student Project Submission Checklist](http://treehouse-techdegree.s3.amazonaws.com/Student-Project-Submission-Checklist.pdf). The checklist is designed to help you make sure you’ve met the grading requirements and that your project is complete and ready to be submitted!
- [x] Don’t forget to revisit the courses you’ve completed as needed and never hesitate to reach out to the Treehouse Community.

#### Extra credit

- [x] Add a feature such that at the end of each round, the users can tap on an event and be presented with a WebView or SafariViewController which will show a web page (such as Wikipedia) with related information. Users can close the webview and resume game play. A sample of this feature is shown in the project mockups.
