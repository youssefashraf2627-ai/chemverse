-- CHEM-VIRSE Admin dashboard permissions
-- 1) Run this file in Supabase SQL Editor after supabase-schema.sql.
-- 2) Create/sign in to the intended admin account in Authentication > Users.
-- 3) Copy that user's UUID and run: insert into public.admin_users(user_id) values ('USER-UUID-HERE');
-- Do NOT allow users to add themselves to admin_users.
create table if not exists public.admin_users (
 user_id uuid primary key references auth.users(id) on delete cascade,
 created_at timestamptz not null default now()
);
alter table public.admin_users enable row level security;
drop policy if exists "admin_users_read_self" on public.admin_users;
create policy "admin_users_read_self" on public.admin_users for select to authenticated using (auth.uid() = user_id);
create or replace function public.is_chemvirse_admin() returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.admin_users where user_id = auth.uid());
$$;
revoke all on function public.is_chemvirse_admin() from public;
grant execute on function public.is_chemvirse_admin() to authenticated;
-- Admin-only writes for academic content. Public read policies from the base schema remain intact.
drop policy if exists "subjects_admin_all" on public.subjects;
create policy "subjects_admin_all" on public.subjects for all to authenticated using (public.is_chemvirse_admin()) with check (public.is_chemvirse_admin());
drop policy if exists "quizzes_admin_all" on public.quizzes;
create policy "quizzes_admin_all" on public.quizzes for all to authenticated using (public.is_chemvirse_admin()) with check (public.is_chemvirse_admin());
drop policy if exists "questions_admin_all" on public.questions;
create policy "questions_admin_all" on public.questions for all to authenticated using (public.is_chemvirse_admin()) with check (public.is_chemvirse_admin());
drop policy if exists "news_admin_all" on public.news;
create policy "news_admin_all" on public.news for all to authenticated using (public.is_chemvirse_admin()) with check (public.is_chemvirse_admin());
drop policy if exists "notes_admin_select" on public.notes;
create policy "notes_admin_select" on public.notes for select to authenticated using (public.is_chemvirse_admin());
drop policy if exists "notes_admin_delete" on public.notes;
create policy "notes_admin_delete" on public.notes for delete to authenticated using (public.is_chemvirse_admin());
-- Storage bucket for lesson files. If it already exists, this statement does not replace its settings.
insert into storage.buckets (id,name,public) values ('course-files','course-files',true) on conflict (id) do nothing;
drop policy if exists "course_files_public_read" on storage.objects;
create policy "course_files_public_read" on storage.objects for select to anon, authenticated using (bucket_id='course-files');
drop policy if exists "course_files_admin_insert" on storage.objects;
create policy "course_files_admin_insert" on storage.objects for insert to authenticated with check (bucket_id='course-files' and public.is_chemvirse_admin());
drop policy if exists "course_files_admin_update" on storage.objects;
create policy "course_files_admin_update" on storage.objects for update to authenticated using (bucket_id='course-files' and public.is_chemvirse_admin()) with check (bucket_id='course-files' and public.is_chemvirse_admin());
drop policy if exists "course_files_admin_delete" on storage.objects;
create policy "course_files_admin_delete" on storage.objects for delete to authenticated using (bucket_id='course-files' and public.is_chemvirse_admin());
