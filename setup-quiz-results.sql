-- تشغيل هذا الملف مرة واحدة في Supabase SQL Editor لإضافة تفاصيل مراجعة إجابات الاختبارات.
alter table public.quiz_results add column if not exists review_details jsonb not null default '[]'::jsonb;
alter table public.quiz_results add column if not exists created_at timestamptz not null default now();

-- تمكين المسؤولين المعتمدين من قراءة نتائج الاختبارات. تعتمد الدالة على جدول admin_users الموجود في مخطط Chemverse.
alter table public.quiz_results enable row level security;
drop policy if exists "quiz_results_admin_select" on public.quiz_results;
create policy "quiz_results_admin_select" on public.quiz_results for select to authenticated using (public.is_chemvirse_admin());
