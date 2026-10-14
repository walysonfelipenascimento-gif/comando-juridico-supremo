-- CJS core schema v2. Apply only to a fresh/reviewed Supabase project.
-- Before production: configure Discord OAuth, RLS tests, backups and server-side authorization.
create extension if not exists pgcrypto;
do $$ begin create type public.cjs_doc_status as enum ('draft','review','approved','published','withdrawn'); exception when duplicate_object then null; end $$;
do $$ begin create type public.cjs_visibility as enum ('public','internal','restricted'); exception when duplicate_object then null; end $$;

create table if not exists public.cjs_profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 discord_id text unique,
 display_name text not null,
 avatar_url text,
 email text,
 status text not null default 'pending' check(status in ('pending','active','suspended','rejected')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.cjs_departments (
 id uuid primary key default gen_random_uuid(), code text unique not null, name text not null,
 description text, active boolean not null default true, created_at timestamptz not null default now()
);
create table if not exists public.cjs_roles (
 id uuid primary key default gen_random_uuid(), code text unique not null, name text not null,
 description text, rank_order integer not null default 0, department_id uuid references public.cjs_departments(id),
 active boolean not null default true, created_at timestamptz not null default now()
);
create table if not exists public.cjs_permissions (
 code text primary key, description text not null
);
create table if not exists public.cjs_role_permissions (
 role_id uuid not null references public.cjs_roles(id) on delete cascade,
 permission_code text not null references public.cjs_permissions(code) on delete cascade,
 primary key(role_id,permission_code)
);
create table if not exists public.cjs_memberships (
 id uuid primary key default gen_random_uuid(), profile_id uuid not null references public.cjs_profiles(id),
 role_id uuid not null references public.cjs_roles(id), department_id uuid references public.cjs_departments(id),
 assigned_by uuid references public.cjs_profiles(id), assigned_at timestamptz not null default now(),
 ended_at timestamptz, notes text
);
create table if not exists public.cjs_access_requests (
 id uuid primary key default gen_random_uuid(), profile_id uuid not null references public.cjs_profiles(id),
 motivation text, status text not null default 'pending' check(status in ('pending','approved','rejected','cancelled')),
 requested_at timestamptz not null default now(), reviewed_by uuid references public.cjs_profiles(id),
 reviewed_at timestamptz, decision_note text
);
create table if not exists public.cjs_documents (
 id uuid primary key default gen_random_uuid(), slug text unique not null, title text not null,
 document_type text not null check(document_type in ('law','regulation','notice','edict','case_law','announcement','other')),
 status public.cjs_doc_status not null default 'draft', visibility public.cjs_visibility not null default 'internal',
 current_version integer not null default 1, effective_at timestamptz, published_at timestamptz,
 created_by uuid references public.cjs_profiles(id), approved_by uuid references public.cjs_profiles(id),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.cjs_document_versions (
 id uuid primary key default gen_random_uuid(), document_id uuid not null references public.cjs_documents(id) on delete cascade,
 version integer not null, body text not null, change_summary text,
 created_by uuid references public.cjs_profiles(id), created_at timestamptz not null default now(),
 unique(document_id,version)
);
create table if not exists public.cjs_courses (
 id uuid primary key default gen_random_uuid(), title text not null, description text,
 version integer not null default 1, passing_score numeric not null default 70 check(passing_score between 0 and 100),
 active boolean not null default false, created_by uuid references public.cjs_profiles(id), created_at timestamptz not null default now()
);
create table if not exists public.cjs_course_lessons (
 id uuid primary key default gen_random_uuid(), course_id uuid not null references public.cjs_courses(id) on delete cascade,
 title text not null, body text not null, position integer not null default 0
);
create table if not exists public.cjs_enrollments (
 id uuid primary key default gen_random_uuid(), course_id uuid not null references public.cjs_courses(id),
 profile_id uuid not null references public.cjs_profiles(id), status text not null default 'enrolled'
 check(status in ('enrolled','in_progress','passed','failed','cancelled')), score numeric,
 enrolled_at timestamptz not null default now(), completed_at timestamptz, unique(course_id,profile_id)
);
create table if not exists public.cjs_assessments (
 id uuid primary key default gen_random_uuid(), course_id uuid not null references public.cjs_courses(id) on delete cascade,
 title text not null, questions jsonb not null default '[]'::jsonb, active boolean not null default false
);
create table if not exists public.cjs_assessment_attempts (
 id uuid primary key default gen_random_uuid(), assessment_id uuid not null references public.cjs_assessments(id),
 profile_id uuid not null references public.cjs_profiles(id), answers jsonb not null default '[]'::jsonb,
 score numeric, submitted_at timestamptz not null default now()
);
create table if not exists public.cjs_tickets (
 id uuid primary key default gen_random_uuid(), requester_id uuid not null references public.cjs_profiles(id),
 title text not null, category text not null default 'general', status text not null default 'open'
 check(status in ('open','in_progress','waiting','closed')), assigned_to uuid references public.cjs_profiles(id),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.cjs_ticket_messages (
 id uuid primary key default gen_random_uuid(), ticket_id uuid not null references public.cjs_tickets(id) on delete cascade,
 author_id uuid not null references public.cjs_profiles(id), body text not null,
 created_at timestamptz not null default now()
);
create table if not exists public.cjs_notifications (
 id uuid primary key default gen_random_uuid(), profile_id uuid not null references public.cjs_profiles(id),
 title text not null, body text not null, channel text not null default 'portal',
 read_at timestamptz, created_at timestamptz not null default now()
);
create table if not exists public.cjs_finance_entries (
 id uuid primary key default gen_random_uuid(), entry_type text not null check(entry_type in ('income','expense')),
 amount numeric(12,2) not null check(amount >= 0), description text not null, category text not null,
 reference_date date not null default current_date, created_by uuid references public.cjs_profiles(id),
 approved_by uuid references public.cjs_profiles(id), created_at timestamptz not null default now()
);
create table if not exists public.cjs_audit_events (
 id bigint generated always as identity primary key, actor_id uuid references public.cjs_profiles(id),
 action text not null, entity_type text not null, entity_id text, details jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create index if not exists cjs_memberships_profile_idx on public.cjs_memberships(profile_id);
create index if not exists cjs_requests_status_idx on public.cjs_access_requests(status,requested_at);
create index if not exists cjs_docs_public_idx on public.cjs_documents(status,visibility,published_at);
create index if not exists cjs_audit_time_idx on public.cjs_audit_events(created_at desc);
create index if not exists cjs_tickets_requester_idx on public.cjs_tickets(requester_id,status);

-- Enable RLS on every table. No client-side admin policies are granted by this migration.
do $$ declare t text; begin
 foreach t in array array['cjs_profiles','cjs_departments','cjs_roles','cjs_permissions','cjs_role_permissions','cjs_memberships','cjs_access_requests','cjs_documents','cjs_document_versions','cjs_courses','cjs_course_lessons','cjs_enrollments','cjs_assessments','cjs_assessment_attempts','cjs_tickets','cjs_ticket_messages','cjs_notifications','cjs_finance_entries','cjs_audit_events']
 loop execute format('alter table public.%I enable row level security',t); end loop;
end $$;

-- Safe baseline: only published public docs and active public courses can be read anonymously.
drop policy if exists cjs_public_documents_read on public.cjs_documents;
create policy cjs_public_documents_read on public.cjs_documents for select to anon, authenticated
using (status='published' and visibility='public');
drop policy if exists cjs_public_courses_read on public.cjs_courses;
create policy cjs_public_courses_read on public.cjs_courses for select to anon, authenticated using (active=true);
-- Users may read their own profile/requests/notifications/tickets. No client writes to roles,
-- permissions, finance, audit, or administrative data are allowed by default.
drop policy if exists cjs_profile_self_read on public.cjs_profiles;
create policy cjs_profile_self_read on public.cjs_profiles for select to authenticated using (id=auth.uid());
drop policy if exists cjs_requests_self_read on public.cjs_access_requests;
create policy cjs_requests_self_read on public.cjs_access_requests for select to authenticated using (profile_id=auth.uid());
drop policy if exists cjs_notifications_self_read on public.cjs_notifications;
create policy cjs_notifications_self_read on public.cjs_notifications for select to authenticated using (profile_id=auth.uid());
drop policy if exists cjs_tickets_self_read on public.cjs_tickets;
create policy cjs_tickets_self_read on public.cjs_tickets for select to authenticated using (requester_id=auth.uid());
-- A trusted server layer must implement permission checks and append audit events. Never expose service keys.
