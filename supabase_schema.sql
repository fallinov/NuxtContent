-- Create the table
create table taches (
  id uuid default gen_random_uuid() primary key,
  libelle text not null,
  date_creation timestamp with time zone default timezone('utc'::text, now()) not null,
  date_fin timestamp with time zone,
  terminee boolean default false not null
);

-- Insert some dummy data
insert into taches (libelle, terminee, date_creation) values
  ('Apprendre Nuxt 4', true, now() - interval '2 days'),
  ('Configurer Supabase', true, now() - interval '1 day'),
  ('Créer la page de tâches', false, now()),
  ('Déployer en production', false, now());

-- Enable Realtime
alter publication supabase_realtime add table taches;
