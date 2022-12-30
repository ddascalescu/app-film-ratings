# Film ratings app
A Flutter app for rating films

TODO (before V1 and public):
 - Make table rows clickable
   - Move delete button here
   - Have full date here, and change main table to only show dec-12 or 2021 if older than current year
   - Edit button?
 - Check layout for multiple mobile devices
 - Name app for mobile
 - Release versions, and update repo description with where to find, also update repo picture(s)
 - Repeat for any other platforms
 - Include indigo somewhere in app
   - Maybe far right of app bar, maybe as logo
   - Maybe also change font to match logo
   - Maybe make lowercase to match logo

Features:
 - Adding film ratings to a table
 - Persistent ratings storage in local file system

![Demo](../assets/assets/windows_main.png?raw=true)

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
   - Changing granularity and scale of ratings - I.e. can set min, max, and step
 - 'date joined' value in 'about' section
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
