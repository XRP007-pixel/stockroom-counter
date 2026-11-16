-- =====================================================================
-- STOCKROOM COUNTER - database setup for Supabase
--
-- Run this ONCE in a new Supabase project:
--   Supabase dashboard > SQL Editor > New query > paste all of this > Run
--
-- It creates four tables and locks each row to the business account that
-- created it, so one business can never read or change another's data.
-- =====================================================================

-- ---------- 1. TABLES ----------

-- One row per business account: its display name.
create table public.businesses (
  owner uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  name  text not null default ''
);

-- The people who sign in with a PIN on a device connected to the business.
create table public.staff (
  id    bigint generated always as identity primary key,
  owner uuid not null default auth.uid() references auth.users (id) on delete cascade,
  name  text not null,
  pin   text not null check (pin ~ '^[0-9]{4}$'),
  role  text not null check (role in ('manager', 'employee')),
  team  text not null default 'all',
  unique (owner, pin)                       -- no two people in one business share a PIN
);

-- The things being counted.
create table public.items (
  id         bigint generated always as identity primary key,
  owner      uuid not null default auth.uid() references auth.users (id) on delete cascade,
  team       text not null,
  area       text not null default 'General',
  name       text not null,
  unit       text not null default 'units',
  on_hand    integer not null default 0 check (on_hand >= 0),
  min_level  integer not null default 0 check (min_level >= 0),
  par_level  integer not null default 0 check (par_level >= 0),
  counted_at timestamptz,
  counted_by text not null default ''
);

-- The history of who changed what.
create table public.activity (
  id         bigint generated always as identity primary key,
  owner      uuid not null default auth.uid() references auth.users (id) on delete cascade,
  who        text not null,
  kind       text not null check (kind in ('count', 'note')),
  item_id    bigint,
  item       text,
  from_count integer,
  to_count   integer,
  note       text,
  created_at timestamptz not null default now()
);

create index staff_owner_idx    on public.staff (owner);
create index items_owner_idx    on public.items (owner);
create index activity_owner_idx on public.activity (owner, created_at desc);

-- ---------- 2. SECURITY ----------
-- Row Level Security: the database itself checks every request.
-- A signed-in business account can only see and change rows where owner = its own id.
-- Anyone who is not signed in gets nothing.

alter table public.businesses enable row level security;
alter table public.staff      enable row level security;
alter table public.items      enable row level security;
alter table public.activity   enable row level security;

create policy "business sees only its own row" on public.businesses
  for all to authenticated
  using ((select auth.uid()) = owner) with check ((select auth.uid()) = owner);

create policy "business sees only its own staff" on public.staff
  for all to authenticated
  using ((select auth.uid()) = owner) with check ((select auth.uid()) = owner);

create policy "business sees only its own items" on public.items
  for all to authenticated
  using ((select auth.uid()) = owner) with check ((select auth.uid()) = owner);

create policy "business sees only its own activity" on public.activity
  for all to authenticated
  using ((select auth.uid()) = owner) with check ((select auth.uid()) = owner);

-- Signed-in accounts may use the tables (the policies above still limit which rows).
-- Accounts that are not signed in get no access at all.
grant select, insert, update, delete on public.businesses, public.staff, public.items, public.activity to authenticated;
revoke all on public.businesses, public.staff, public.items, public.activity from anon;

-- ---------- 3. LIVE UPDATES ----------
-- Lets a second tablet see a count the moment the first tablet saves it.

alter publication supabase_realtime add table public.businesses, public.staff, public.items, public.activity;
