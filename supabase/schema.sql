create extension if not exists pgcrypto;

create table if not exists public.rifas (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  descricao text,
  imagem_url text,
  preco_cota numeric(10,2) not null default 0,
  total_cotas integer not null default 100,
  status text not null default 'rascunho',
  created_at timestamptz not null default now()
);

create table if not exists public.pedidos (
  id uuid primary key default gen_random_uuid(),
  rifa_id uuid not null references public.rifas(id),
  nome_comprador text not null,
  email_comprador text not null,
  cotas integer[] not null,
  valor_total numeric(10,2) not null,
  comprovante_url text,
  status text not null default 'aguardando_pagamento',
  created_at timestamptz not null default now()
);
