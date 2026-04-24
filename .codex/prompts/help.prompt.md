---
description: Lista todos os recursos do pacote de tutoria JaCaMo disponíveis neste projeto: agent, skill, prompts e arquivos de referência. Use /help para saber o que existe e como usar.
---

Leia `PROGRESS.md` para personalizar a resposta com o módulo atual do aluno.

---

Exiba o guia completo do pacote de tutoria JaCaMo, em português do Brasil, no formato abaixo:

---

# Guia do Tutor JaCaMo

## O que está disponível

Este projeto inclui um pacote completo de tutoria para JaCaMo 1.3.0, composto por:
um agent especializado, uma skill de ensino, seis prompts como slash commands
e arquivos de teoria por módulo.

---

## Agent — `@jacamo-tutor`

**Como usar:** selecione **jacamo-tutor** no dropdown de agentes do chat (ao lado de "Agent").

**O que faz:**
- Lê `PROGRESS.md` ao iniciar e pergunta onde você está
- Conduz sessões completas de tutoria (teoria → exercício → correção → progressão)
- Tem acesso aos arquivos do `src/` para gerar exercícios baseados no código real
- Usa tom socrático — nunca entrega a resposta diretamente na primeira tentativa
- Ao finalizar exercícios, lembra de atualizar `PROGRESS.md`

**Melhor para:** sessões completas de estudo, quando você quer que o tutor conduza tudo.

---

## Skill — `jacamo-tutor`

**Como usar:** invocada automaticamente pelo Copilot quando relevante, ou com `/jacamo-tutor` no chat.

**O que define:**
- Fluxo de ensino: AULA → CONCEITO → EXEMPLO → EXERCÍCIO → DICA → CORREÇÃO → DECISÃO
- Rubrica de correção com 4 critérios (corretude, sintaxe, estrutura, idioms)
- Regras de progressão entre módulos
- Formato padrão de exercícios e correções

**Melhor para:** qualquer conversa sobre JaCaMo no chat — a skill é carregada automaticamente.

---

## Slash commands disponíveis

### `/aula [módulo]`
**Parâmetro:** número do módulo (0–8). Se omitido, usa o módulo atual do `PROGRESS.md`.

**O que faz:** entrega a aula teórica completa do módulo:
teoria → código anotado → mini-quiz de verificação.
O exercício prático só é sugerido **após** o quiz.

**Exemplo:** `/aula 2` → aula sobre Beliefs, Goals e Plans (Jason/AgentSpeak)

---

### `/exercicio [módulo] [nível]`
**Parâmetros:** módulo (0–8) e nível (`intro` / `consolidação` / `desafio`).

**O que faz:** gera um exercício contextualizado no código real do projeto (`src/`),
com enunciado, critérios de aceite, instrução de teste e dica oculta em `<details>`.

**Exemplo:** `/exercicio 3 intro` → exercício introdutório sobre artefatos CArtAgO

---

### `/corrigir-exercicio`
**Uso:** após o slash command, cole o enunciado do exercício e sua solução (código `.asl`, `.java` ou `.jcm`).

**O que faz:** dica primeiro (estilo socrático). Correção completa com rubrica só se você pedir
ou após duas tentativas.

**Exemplo:** `/corrigir-exercicio` → [cole o código] → recebe dica → pede correção completa se quiser

---

### `/proximo-passo [módulo]`
**Parâmetro:** módulo atual (opcional — usa `PROGRESS.md` se omitido).

**O que faz:** decide com base no desempenho se você deve **avançar**, **reforçar** ou **revisitar**,
com referência à seção exata do `ROADMAP.md` e sugestão de exercício.

**Exemplo:** `/proximo-passo 2` → "Avançar para Módulo 3: CArtAgO — use `/aula 3`"

---

### `/plano-de-ensino`
**Parâmetro:** nenhum obrigatório (parâmetros opcionais: duração, horas/semana).

**O que faz:** gera a tabela completa dos 9 módulos com objetivos de aprendizagem,
exercícios esperados e checkpoints de progressão. Mostra onde você está com base no `PROGRESS.md`.

**Exemplo:** `/plano-de-ensino` → visão geral dos 9 módulos com seu status atual

---

### `/help`
Este comando — lista tudo que está disponível no pacote.

---

## Arquivos de referência no projeto

| Arquivo | Para que serve |
|---------|---------------|
| `ROADMAP.md` | Currículo completo dos 9 módulos com exemplos e links |
| `PROGRESS.md` | Seu progresso atual — módulo, exercícios feitos, observações do tutor |
| `doc/modulo-0.md` … `doc/modulo-8.md` | Teoria didática por módulo (base para `/aula`) |
| `.github/copilot-instructions.md` | Instruções globais do projeto para o Copilot |
| `src/agt/sample_agent.asl` | Agente BDI de referência |
| `src/env/example/Counter.java` | Artefato CArtAgO de referência |
| `learn_jacamo.jcm` | Ponto de entrada do MAS |

---

## Fluxo de uso recomendado por sessão

```
1. /aula [módulo]          → estude a teoria e complete o mini-quiz
2. /exercicio [N] intro    → pratique com exercício introdutório
3. /corrigir-exercicio     → corrija sua solução
4. /exercicio [N] consolidação  → pratique mais se quiser reforçar
5. /proximo-passo          → decida se avança ou reforça
6. Atualize PROGRESS.md   → registre o que foi feito
```

---

## Módulos do currículo

| # | Tópico | Tecnologia |
|---|--------|------------|
| 0 | MAOP, BDI e visão geral | Conceitual |
| 1 | Estrutura do projeto e primeiros passos | JaCaMo (.jcm) |
| 2 | Crenças, Metas e Planos | Jason/AgentSpeak |
| 3 | Artefatos e Workspaces | CArtAgO |
| 4 | Grupos, Papéis e Esquemas | Moise |
| 5 | Coordenação: as três dimensões | Jason + CArtAgO + Moise |
| 6 | Exemplo avançado: Gold Miners | Integrado |
| 7 | Debug, testes e boas práticas | JaCaMo + Jason |
| 8 | Projeto final | Integrado |

---

> **Dica:** use `@jacamo-tutor` para uma sessão completa onde o tutor conduz tudo.
> Use os slash commands quando quiser controle direto sobre cada etapa.

---
