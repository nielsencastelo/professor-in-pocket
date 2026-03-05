-- Executa na primeira inicialização do container
CREATE EXTENSION IF NOT EXISTS vector;

-- Schema do Professor in Pocket
CREATE SCHEMA IF NOT EXISTS pip;

-- Tabela de "documentos" (materiais de disciplina)
-- Ex: plano_ensino.pdf, apostila.docx, slides_01.pdf etc.
CREATE TABLE IF NOT EXISTS pip.docs (
  id            BIGSERIAL PRIMARY KEY,
  doc_key       TEXT UNIQUE,             -- ex: "engcomp-programacao-plano-2025"
  disciplina    TEXT NOT NULL,           -- ex: "programacao", "robotica"
  titulo        TEXT,
  tipo          TEXT,                    -- ex: "plano", "apostila", "slides", "artigo"
  tags          TEXT[],                  -- opcional (assuntos, unidades, tópicos)
  file_path     TEXT,                    -- caminho/arquivo de origem
  source_url    TEXT,                    -- se veio da web (opcional)
  updated_at    TIMESTAMPTZ DEFAULT now()
);

-- Tabela de chunks com embeddings (RAG)
-- Dimensão: BAAI/bge-m3 = 1024
CREATE TABLE IF NOT EXISTS pip.chunks (
  id            BIGSERIAL PRIMARY KEY,
  doc_key       TEXT REFERENCES pip.docs(doc_key) ON DELETE CASCADE,
  chunk_id      INT NOT NULL,
  content       TEXT NOT NULL,
  embedding     vector(1024),
  updated_at    TIMESTAMPTZ DEFAULT now(),
  UNIQUE (doc_key, chunk_id)
);

-- Controle de indexação (evita reprocessar os mesmos arquivos)
CREATE TABLE IF NOT EXISTS pip.embed_control (
  doc_key        TEXT PRIMARY KEY,
  content_hash   TEXT NOT NULL,
  embedded_at    TIMESTAMPTZ,
  model_name     TEXT DEFAULT 'BAAI/bge-m3',
  embed_dim      INT DEFAULT 1024
);

-- Índices úteis
CREATE INDEX IF NOT EXISTS idx_pip_docs_disciplina ON pip.docs(disciplina);
CREATE INDEX IF NOT EXISTS idx_pip_chunks_doc_key ON pip.chunks(doc_key);

-- IVFFlat para COSINE
-- Observação: IVFFlat funciona melhor quando há volume (centenas/milhares+ de vetores).
-- Você pode ajustar lists depois (ex: 100, 200, 400).
CREATE INDEX IF NOT EXISTS idx_pip_chunks_emb_cos
ON pip.chunks USING ivfflat (embedding vector_cosine_ops) WITH (lists = 200);