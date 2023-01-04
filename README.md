# Film ratings app
A Flutter app for rating films and data visualization.

Versions:
 - Android: (Pre-release) 0.1.0 - Google Play internal testing, link available on request
 - Windows: (Pre-release) [0.1.0](https://github.com/ddascalescu/app-film-ratings/releases/tag/0.1.0)

Features:
 - Adding film ratings to a table
 - Persistent ratings storage in local file system

Windows example:  
<img src="../assets/assets/windows_main.png?raw=true" width="750">  
Mobile examples:  
<img src="../assets/assets/xperia_main.png?raw=true" width="250">
<img src="../assets/assets/xperia_dialog_add.png?raw=true" width="250">
<img src="../assets/assets/xperia_dialog_details.png?raw=true" width="250">

In progress (active): Version 0.1.1:
 - Small layout/design edits
 - Fixing any issues arising from 0.1.0 testing
 - Releasing on iOS

Planned features:
 - Add dropdown with options like 'first viewing', 'repeat viewing', 'imdb import', 'changed mind', 'other', & custom
 - Changing adding entries into a '+' button that brings up a box, involving the next point
 - Make main table sortable by any column
 - Make columns hidable
 - Searching through IMDb API for films (maybe storing them all in useful format? depends on format they appear in API and how easy retrieval is. cache may be nice for offline use)
 - Analytics
   - Numbers for specific film/director/actor/genre etc. (box with info)
     - average rating, times seen, most watched film by-director/with-actor/in-genre
     - ratings graph over time
   - Ranking charts for film/director/actor/genre etc. (horizontal bar chart)
     - by: average ratings, times seen
     - sort high/low
   - Distribution charts (vertical bar chart)
     - number of times rated 0-1, 1-2, 2-3, etc. (option for granularity)
     - number of times rating a year
 - Define custom analytics that the user wants to see often, display on main analytics screen
 - Settings
   - Visual: light/dark theme
   - Change between long-form and short-form of date in main table (some may want to see specific dates when sorting by date older than current year), maybe don't allow on devices where room is not sufficient
   - Changing granularity and scale of ratings - I.e. can set min, max, and step
   - Info/about
     - Version name/number
     - 'date joined' value
       - can include as line in date-based charts, to distinguish between old and new rating systems
 - Syncing save files between devices - maybe gdrive?
 - Exporting data
   - json, csv, etc.
   - export chart PNGs
 - Anonymous user data sending - collate averages across all users, generate recommendations etc.
 - Automatically update hint in 'Add rating' box - maybe user suggestions?, if done the above point then maybe most popular of the week
 - Make loading intro screen, showing logo
 
#
[Dan Dascalescu](https://github.com/ddascalescu)
