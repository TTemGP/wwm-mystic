-- 연운 비결 재료 계산기: 유저별 저장값
-- Supabase 대시보드 > SQL Editor 에 통째로 붙여넣고 Run 하세요. 여러 번 실행해도 괜찮아요.

create table if not exists public.user_state (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  -- 한 사람당 저장값은 수 KB라 256KB를 넘으면 거절해요(남용 방지)
  constraint user_state_size check (pg_column_size(data) <= 262144)
);

-- 행 단위 보안(RLS): 켜 두면 아래 정책에 맞는 행만 읽고 쓸 수 있어요
alter table public.user_state enable row level security;
alter table public.user_state force row level security;

-- 로그인 안 한 사용자(anon)는 이 테이블에 아무 권한도 없어요
revoke all on public.user_state from anon;
revoke all on public.user_state from public;
grant select, insert, update, delete on public.user_state to authenticated;

drop policy if exists "own row select" on public.user_state;
drop policy if exists "own row insert" on public.user_state;
drop policy if exists "own row update" on public.user_state;
drop policy if exists "own row delete" on public.user_state;

-- 로그인한 사용자는 자기 user_id 행만 볼 수 있어요
create policy "own row select" on public.user_state
  for select to authenticated using ((select auth.uid()) = user_id);
-- 자기 user_id로만 새 행을 만들 수 있어요
create policy "own row insert" on public.user_state
  for insert to authenticated with check ((select auth.uid()) = user_id);
-- 자기 행만 고칠 수 있고, 다른 사람 user_id로 바꿔치기도 못 해요
create policy "own row update" on public.user_state
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
-- 자기 행만 지울 수 있어요
create policy "own row delete" on public.user_state
  for delete to authenticated using ((select auth.uid()) = user_id);

-- updated_at은 서버 시간으로만 기록해요
create or replace function public.user_state_touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end $$;
drop trigger if exists user_state_touch on public.user_state;
create trigger user_state_touch before insert or update on public.user_state
  for each row execute function public.user_state_touch();
