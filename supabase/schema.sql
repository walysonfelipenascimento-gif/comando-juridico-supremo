-- CJS initial schema draft. Review and test before production.
create extension if not exists pgcrypto;

create type public.document_status as enum ('draft','review','approved','published','withdrawn');
create type public.document_visibility as enum ('public','internal','restricted');

create table public.profiles (
  id uuid primary key default gen_random_uuid(),
  discord_id text unique,
  display_name text not null,
  email text,
  avatar_url text,
  status text not null default 'pending' check (status in ('pending','active','suspended','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.departments (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  description text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.roles (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  description text,
  rank_order integer not null,
  department_id uuid references public.departments(id),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.memberships (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id),
  role_id uuid not null references public.roles(id),
  department_id uuid references public.departments(id),
  assigned_by uuid references public.profiles(id),
  assigned_at timestamptz not null default now(),
  ended_at timestamptz,
  notes text
);

create table public.access_requests (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id),
  requested_at timestamptz not null default now(),
  status text not null default 'pending' check (status in ('pending','approved','rejected','cancelled')),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  decision_note text
);

create table public.documents (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  document_type text not null check (document_type in ('law','regulation','notice','edict','case_law','announcement','other')),
  status public.document_status not null default 'draft',
  visibility public.document_visibility not null default 'internal',
  current_version integer not null default 1,
  effective_at timestamptz,
  published_at timestamptz,
  created_by uuid references public.profiles(id),
  approved_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.document_versions (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(id),
  version integer not null,
  body text not null,
  change_summary text,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  unique(document_id, version)
);

create table public.courses (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  version integer not null default 1,
  active boolean not null default false,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.course_enrollments (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id),
  profile_id uuid not null references public.profiles(id),
  status text not null default 'enrolled' check (status in ('enrolled','in_progress','passed','failed','cancelled')),
  score numeric,
  completed_at timestamptz,
  unique(course_id, profile_id)
);

create table public.audit_events (
  id uuid primary key default gen_random_uuid(),
  actor_profile_id uuid references public.profiles(id),
  action text not null,
  entity_type text not null,
  entity_id text,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index memberships_profile_idx on public.memberships(profile_id);
create index access_requests_status_idx on public.access_requests(status);
create index documents_publication_idx on public.documents(status, visibility, published_at);
create index audit_events_created_idx on public.audit_events(created_at desc);

-- IMPORTANT: Row Level Security policies, role checks, OAuth identity verification,
-- append-only audit enforcement, and privileged server actions must be implemented
-- before connecting this draft schema to production. Do not expose service-role keys.
