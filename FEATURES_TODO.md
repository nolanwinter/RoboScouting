Currently Implemented Features:
- Customizable data input "objects"
  - Increment/Decrement input with plus and minus buttons
  - Radio button (colored or uncolored) for Yes/No questions
  - Multiple radio selection with varying number of options and customizable option colors
  - Free form text input - currently meant for only one to exist
  - Free form number input
  - Generate QR Code
- Submit/continue and back buttons
- Start New Match / Save data button
- Save match data on phone in text file
- Display match data in the form of a QR code
- Match number automatically increments each match
- Scout name and team selector remain between matches
- Use number-only keyboard for match and team number inputs
- Keyboards are hidden when clicking away or pressing enter
- Confirmation popup to prevent accidental match reset
- View the last 50 QR codes

TODO:
- Include proper attribution for qr code generator
- Handle scenes that destroy themselves after a long time going unused (may not be important despite being a bug)
- Make a sceneGroup variable in objects that gets set everytime a scene is created or shown and then remove that paramter from each display object
- Turn all default display values (headings, etc.) into objects for cleaner, more readable scenes
- Change all objects to use the top as a y_val (x_val can be either left or middle based on type of object?)
- Handle negative numbers (currently not planned/needed)
