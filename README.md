# Film ratings app
A Flutter app for rating films and data visualization.

Versions:
 - Android: (Pre-release)
   - Google Play: Not yet released
   - APK: [0.2.0](https://github.com/ddascalescu/app-film-ratings/releases/tag/v0.2.0-alpha-android)
 - iOS: Not yet released
 - Windows: (Pre-release) [0.2.0](https://github.com/ddascalescu/app-film-ratings/releases/tag/v0.2.0-alpha)
 - Web: Not yet completed
 - Linux: Not yet completed
 - macOS: Not yet completed

Features:
 - Adding film ratings to a table
 - Persistent ratings storage in local file system

Windows example:  
<img src="../assets/assets/windows_main.png?raw=true" width="750">  
Mobile examples:  
<img src="../assets/assets/xperia_main.png?raw=true" width="250">
<img src="../assets/assets/xperia_dialog_add.png?raw=true" width="250">
<img src="../assets/assets/xperia_dialog_details.png?raw=true" width="250">

#

In progress (on hold since Jan-27): Version 0.2.1:
 - Adding backward compatibility and redundancy
 - Minor feature changes

[Full changelog](https://github.com/ddascalescu/app-film-ratings/blob/main/changelog.txt)

Planned features:
 - Make main table sortable by any column
 - Make columns hideable
 - More rating criteria
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
 - Voice input
 - Friends
   - See data
   - Set public/private data
 
#
[Dan Dascalescu](https://github.com/ddascalescu)
