-- Schéma optionnel si l'utilisateur choisit le stockage en base (Option 2)
-- Supabase / PostgreSQL

create table if not exists project_memory (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('map', 'state', 'refusal', 'error', 'success', 'decision')),
  title text not null,
  content text not null,
  tags text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists idx_memory_kind on project_memory(kind);
create index if not exists idx_memory_tags on project_memory using gin(tags);

-- Vue d'accès rapide pour le réveil (l'équivalent de MAP + STATE + REFUSALS)
create or replace view v_wake_context as
select kind, title, content, updated_at
from project_memory
where kind in ('map', 'state', 'refusal')
order by updated_at desc;
