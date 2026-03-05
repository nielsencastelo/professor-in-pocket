
# Professor in Pocket — POC (Phi-4 + Multi-Agentes + RAG futuro)

POC do projeto **Professor in Pocket**: um tutor acadêmico para cursos de **Engenharia de Computação**, baseado em **LLM local (Phi-4)** com **arquitetura multi-agente**.

A proposta valida um modelo de tutor que:

- entende a pergunta do aluno
- identifica a disciplina automaticamente
- gera explicações didáticas
- avalia e melhora a própria resposta
- prepara a arquitetura para **RAG com material oficial**

Nesta primeira fase o sistema roda **localmente e sem RAG**, usando apenas o modelo.

---

# 1) Objetivo da POC

Validar a arquitetura principal do tutor:

- responder perguntas técnicas de disciplinas de engenharia
- estruturar a resposta de forma didática
- aplicar **avaliação automática da resposta**
- refinar respostas automaticamente quando necessário
- preparar o pipeline para **RAG com material oficial**

A ideia central é construir um **professor virtual especializado por disciplina**, com uma camada de orquestração responsável por encaminhar perguntas para o agente correto.

---

# 2) Arquitetura (POC atual)

A arquitetura implementada no notebook segue um **workflow multi-agente**.

Aluno → Router Agent → Tutor Agent → Assessor Agent → Refiner Agent

## Router Agent

Responsável por:

- identificar a disciplina
- identificar o tipo de pergunta
- estimar o nível de dificuldade

Saída estruturada:

{
  disciplina,
  modo,
  dificuldade,
  precisa_clarificar,
  tags
}

---

## Tutor Agent

Responsável por gerar a resposta didática.

Estrutura da resposta:

- explicação em Markdown
- pontos chave
- exemplo de código (quando aplicável)
- mini-quiz
- próximos passos
- leituras recomendadas

---

## Assessor Agent

Avalia automaticamente a resposta do tutor.

Critérios:

- correção técnica
- clareza
- didática
- cobertura da pergunta
- risco de alucinação

Saída:

{
 score_0a10,
 pronto,
 problemas,
 melhorias
}

---

## Refiner Agent

Se a resposta não atingir o nível mínimo de qualidade:

- reescreve a resposta
- corrige problemas
- aplica melhorias sugeridas

---

# 3) Stack Tecnológica

## LLM

**Phi-4 rodando localmente via Ollama**

Motivos:

- roda offline
- baixo custo
- fácil integração HTTP
- adequado para POC

https://github.com/ollama/ollama

---

## Orquestração de agentes

Implementada diretamente em Python no notebook.

Inspirado em padrões usados em:

- LangGraph
- CrewAI
- Agentic workflows

---

## Saída estruturada

Todos os agentes retornam **JSON validado com Pydantic**.

Isso garante:

- consistência de respostas
- fácil logging
- fácil integração com APIs

---

# 4) Arquitetura (RAG)

A próxima etapa adicionará **RAG com material oficial das disciplinas**.

Pipeline planejado:

Material → Docling → Chunking → Embeddings → PGVector → Retrieval → Phi-4

## Ingestão

Conversão de documentos usando **Docling**.

Suporte planejado:

- PDF
- DOCX
- TXT

https://github.com/docling-project/docling

---

## Embeddings

Modelo recomendado:

BAAI/bge-m3

https://huggingface.co/BAAI/bge-m3

---

## Vector Database

PostgreSQL + PGVector

https://github.com/pgvector/pgvector

---

# 5) Quickstart

## Instalar Ollama

https://ollama.com

## Baixar o modelo

ollama pull phi4

## Rodar o notebook

Execute:

notebook_phi4_professor_in_pocket.ipynb

---

# 6) Como validar a POC

Pergunta técnica:

Explique deadlock e as quatro condições necessárias.

Esperado:

- explicação correta
- estrutura didática
- mini-quiz

Pergunta fora de contexto:

Qual é a cor favorita do reitor?

Esperado:

- resposta indicando falta de base
- não inventar informação

---

# 7) Estrutura do Projeto

.
├─ notebooks/
│  └─ notebook_phi4_professor_in_pocket.ipynb
├─ data/
│  └─ disciplinas/
│     └─ eng_comp_programacao/
│        ├─ plano_ensino.pdf
│        ├─ apostila.docx
│        └─ slides/
├─ docker/
│  └─ pgvector/
├─ init/
│  └─ init.sql
└─ README.md

---

# 8) Roadmap

Fase 1 — Multi-Agentes (atual)

- Router agent
- Tutor agent
- Assessor agent
- Refiner agent

Fase 2 — RAG

- ingestão de documentos
- embeddings
- recuperação semântica
- resposta com **fontes auditáveis**

Fase 3 — Plataforma

- API REST
- múltiplas disciplinas
- painel de métricas
- avaliação automática de respostas


