-- CJS onboarding and baseline RLS policies; applied to Supabase project axyalhnmgczdcodwydpd.
-- Administrative writes remain disabled until server-side permission checks are tested.
create or replace function public.cjs_sync_auth_profile()
returns trigger language plpgsql security definer set search_path = ''
as $$
declare v_name text; v_avatar text; v_discord_id text;
begin
 v_name := coalesce(nullif(new.raw_user_meta_data ->> 'global_name',''),nullif(new.raw_user_meta_data ->> 'full_name',''),nullif(new.raw_user_meta_data ->> 'name',''),nullif(new.raw_user_meta_data ->> 'preferred_username',''),nullif(split_part(coalesce(new.email,'Membro CJS'),'@',1),''),'Membro CJS');
 v_avatar := coalesce(nullif(new.raw_user_meta_data ->> 'avatar_url',''),nullif(new.raw_user_meta_data ->> 'picture',''));
 v_discord_id := coalesce(nullif(new.raw_user_meta_data ->> 'provider_id',''),nullif(new.raw_user_meta_data ->> 'sub',''));
 insert into public.cjs_profiles(id,discord_id,display_name,avatar_url,email,status)
 values(new.id,v_discord_id,v_name,v_avatar,new.email,'pending')
 on conflict(id) do update set display_name=excluded.display_name,avatar_url=excluded.avatar_url,email=excluded.email,updated_at=now();
 return new;
end; $$;
drop trigger if exists cjs_auth_user_profile_sync on auth.users;
create trigger cjs_auth_user_profile_sync after insert or update of raw_user_meta_data,email on auth.users for each row execute function public.cjs_sync_auth_profile();

drop policy if exists cjs_departments_public_read on public.cjs_departments;
create policy cjs_departments_public_read on public.cjs_departments for select to anon,authenticated using(active=true);
drop policy if exists cjs_roles_public_read on public.cjs_roles;
create policy cjs_roles_public_read on public.cjs_roles for select to anon,authenticated using(active=true);
drop policy if exists cjs_requests_self_create on public.cjs_access_requests;
create policy cjs_requests_self_create on public.cjs_access_requests for insert to authenticated with check(profile_id=auth.uid() and status='pending' and reviewed_by is null and reviewed_at is null);
drop policy if exists cjs_tickets_self_create on public.cjs_tickets;
create policy cjs_tickets_self_create on public.cjs_tickets for insert to authenticated with check(requester_id=auth.uid() and assigned_to is null and status='open');
drop policy if exists cjs_ticket_messages_self_read on public.cjs_ticket_messages;
create policy cjs_ticket_messages_self_read on public.cjs_ticket_messages for select to authenticated using(exists(select 1 from public.cjs_tickets t where t.id=ticket_id and t.requester_id=auth.uid()));
drop policy if exists cjs_ticket_messages_self_create on public.cjs_ticket_messages;
create policy cjs_ticket_messages_self_create on public.cjs_ticket_messages for insert to authenticated with check(author_id=auth.uid() and exists(select 1 from public.cjs_tickets t where t.id=ticket_id and t.requester_id=auth.uid() and t.status <> 'closed'));
drop policy if exists cjs_enrollments_self_read on public.cjs_enrollments;
create policy cjs_enrollments_self_read on public.cjs_enrollments for select to authenticated using(profile_id=auth.uid());
drop policy if exists cjs_assessment_attempts_self_read on public.cjs_assessment_attempts;
create policy cjs_assessment_attempts_self_read on public.cjs_assessment_attempts for select to authenticated using(profile_id=auth.uid());
