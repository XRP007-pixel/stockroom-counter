STOCKROOM COUNTER - database version (Supabase)

Every device signed in to the same business account shares the same items,
staff and counts. Each business account can only see its own data.

FILES
  index.html             the app (screens, buttons, database code)
  setup.sql              creates the database tables and security rules
  manifest.webmanifest   app name, icon and colors for installing
  sw.js                  keeps a copy of the app's files so it opens quickly
  icon-192.png / icon-512.png   the home-screen icon

SETUP (about 15 minutes)

1. Create the project
   Sign in at supabase.com and create a NEW project for this app.
   Keep it separate from any other app's project.

2. Create the tables
   Open SQL Editor > New query. Paste everything from setup.sql. Click Run.
   It should finish with no errors. Run it only once.

3. Copy the two public values
   Open Project Settings > API Keys. Copy:
     - the project URL (looks like https://abcdefgh.supabase.co)
     - the PUBLISHABLE key (starts with sb_publishable_)
   Never copy a key that starts with sb_secret_ or is labeled service_role.

4. Paste them into the app
   Open index.html in a text editor. Near the top of the script find:
     const SUPABASE_URL = "PASTE_YOUR_PROJECT_URL_HERE";
     const SUPABASE_KEY = "PASTE_YOUR_PUBLISHABLE_KEY_HERE";
   Replace the text between each pair of quotes. Save.

5. Put it online
   Drag this folder onto Netlify, the same way as before.
   setup.sql and README.txt do not need to be online; you can remove them
   from the folder first.

6. Tell Supabase your web address
   In Supabase open Authentication > URL Configuration and set Site URL to
   your Netlify address. Confirmation emails link back to that address.

7. Create the business account
   Open your Netlify address. Choose "Create a new business account".
   If Supabase asks you to confirm by email, click the link in the email,
   then sign in. Create the first manager PIN, then add items and staff.

8. Add more devices
   On each tablet or phone, open the address and sign in with the same
   email and password. Staff then use their PINs.

IF SOMETHING GOES WRONG
  "Could not load" or a permission error right after signing in:
      setup.sql did not finish. Run it again in a fresh project, or check
      Project Settings > Data API that the public schema is exposed.
  No confirmation email arrives:
      Check spam. Supabase's built-in email is limited to a few messages an
      hour. For testing you can turn off "Confirm email" under
      Authentication > Sign In / Providers > Email.
  A second device does not update instantly:
      It still catches up within 30 seconds. Check Database > Publications
      that the four tables are switched on under supabase_realtime.

GOOD TO KNOW
  - Counting needs an internet connection.
  - Anyone signed in to the business account on a device can read the staff
    PINs from the database. The email and password are the real lock; share
    them only with people you trust to set up a device.
  - Turn on backups, or use Manage items > Settings > Copy backup regularly.
