# Stockroom Counter

A tablet app for counting inventory by tapping. Built for small businesses that still count stock on paper.

## What it does

- Staff sign in with a 4-digit PIN and see only their own team's items
- Plus and minus buttons change counts; every count is saved with a name and a time
- Items below their minimum are flagged and added to a reorder list with order amounts
- Managers see an overview of all teams and manage items and staff
- Every device signed in to the same business account shares live data
- Each business account can only see its own data

## How it's built

- HTML, CSS and JavaScript in a single page, with no framework
- Supabase for the database, sign-in and live updates
- Row Level Security so each business is isolated at the database level
- Installable on a tablet home screen as a web app

## Files

| File | Purpose |
|---|---|
| `index.html` | The app: screens, logic and database code |
| `setup.sql` | Creates the database tables and security rules |
| `sw.js`, `manifest.webmanifest`, icons | Make the app installable |
| `README.txt` | Step-by-step setup guide |

## Status

Working and in testing with a first business.
