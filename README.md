# Professor in Pocket — POC (Phi-4 + RAG local)

POC do projeto **Professor in Pocket**: um tutor acadêmico baseado **exclusivamente** em material oficial de disciplinas, com **agentes especializados por área** e uma **camada de orquestração** para encaminhar perguntas.  
Esta POC valida o núcleo técnico: **ingestão → indexação semântica → recuperação (RAG) → resposta com fontes**.

## 1) Objetivo da POC
Validar rapidamente que conseguimos:
- Responder perguntas em linguagem natural com base no material oficial (sem “inventar”).  
- Citar **fontes** (trechos + documento).  
- Roteamento simples (classificador) para “disciplina/agente” e fallback.

Esses pontos estão alinhados ao objetivo e arquitetura descritos na proposta.  

## 2) Arquitetura (mínimo viável)
**(A) Ingestão**
- Carrega arquivos (PDF/DOCX/TXT/MD) de uma disciplina.
- Faz chunking (pedaços) com sobreposição.

**(B) Indexação semântica**
- Gera embeddings com **BAAI/bge-m3** (modelo recomendado para RAG).
- Armazena vetores no **PGVector** (persistente).

**(C) Orquestração**
- Um “Agente Classificador” (heurístico/LLM) decide a área/disciplina.
- Seleciona o “Agente da Disciplina” correspondente.

**(D) Resposta (Phi-4)**
- Faz recuperação top-k (RAG).
- Monta prompt com contexto + regras (só usar material).
- Retorna resposta + “Fontes”.

## 3) Stack sugerida (local, notebook-friendly)
- **Ollama** para rodar o LLM local (Phi-4) via API HTTP.
- **PGVector** como vector store.
- **sentence-transformers** para embeddings (bge-m3).
- Notebook Jupyter.

### Por que isso é uma boa escolha?
- Roda local (bom para POC e privacidade).
- Pipeline simples e testável.
- Fácil evoluir para API depois.

## 4) Quickstart (Notebook)
1) Instale dependências e suba o Ollama.
2) Baixe o modelo Phi-4:
   - `ollama pull phi4`
3) Rode as células do notebook:
   - Ingestão e indexação
   - Perguntas e respostas com fontes

## 5) Como validar (checklist objetivo)
- [ ] Pergunta de conteúdo do material → resposta correta + fontes coerentes  
- [ ] Pergunta fora do material → resposta deve dizer que não encontrou base suficiente  
- [ ] Pergunta ambígua → pede contexto ou sugere onde procurar no material  
- [ ] Roteamento para disciplina correta (mesmo que heurístico)

## 6) Estrutura sugerida do repositório
.
├─ notebooks/
│  └─ poc_professor_in_pocket_phi4_rag.ipynb
├─ data/
│  └─ disciplinas/
│     └─ eng_comp_programacao/
│        ├─ plano_ensino.pdf
│        ├─ apostila.docx
│        └─ slides/
├─ chroma_db/                 # persistência do índice vetorial
└─ README.md

## 7) Próximos passos (depois da POC)
- Agente Classificador treinável (intents + cursos/disciplinas).
- Multi-agentes reais por disciplina (cada um com seu índice).
- Camada de API (FastAPI) + autenticação + logs.
- Observabilidade: métricas de cobertura, taxa de “não sei”, feedback do aluno.
- Guardrails: políticas de “somente material oficial”.

## Referências (docs)
- Ollama API /chat: https://docs.ollama.com/api/chat
- Ollama base URL: https://docs.ollama.com/api/introduction
- Tags do Phi-4 no Ollama: https://ollama.com/library/phi4/tags
- BGE-M3 (model card): https://huggingface.co/BAAI/bge-m3
- Chroma (getting started): https://docs.trychroma.com/docs/overview/getting-started