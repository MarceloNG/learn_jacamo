---
description: Inicia a aula teórica de um módulo JaCaMo. Uso: /aula [módulo 0-8]. Apresenta os conceitos, código anotado, referências oficiais e termina com mini-quiz de verificação. O exercício prático só é sugerido após o quiz.
---

Leia os seguintes arquivos antes de responder:
- `doc/modulo-${input:modulo}.md` (teoria do módulo solicitado)
- A seção correspondente do `ROADMAP.md`
- `PROGRESS.md` (contexto atual do aluno)

Se o módulo não for especificado, consulte `PROGRESS.md` e use o módulo atual.

---

## Estrutura da aula

Entregue a aula em **quatro partes**, na ordem:

---

### Parte 1 — Por que este módulo importa

2–3 parágrafos motivando o tema:
- Que problema este módulo resolve?
- O que você **não consegue fazer** sem dominar este conteúdo?
- Uma analogia com Python que torne o conceito tangível (quando couber)

---

### Parte 2 — Conceitos fundamentais

Explique cada conceito-chave do módulo com:
- Definição em 1–2 frases
- Exemplo de sintaxe anotado (com `← comentários inline` para cada parte relevante)
- Como aparece no projeto `learn_jacamo` (referencie arquivos reais de `src/`)

Use tabelas e blocos de código para clareza. Separe explicitamente o que é **Jason**, **CArtAgO** ou **Moise**.

---

### Parte 3 — Leitura do código real

Abra o(s) arquivo(s) relevante(s) do projeto e mostre o trecho de código mais representativo do módulo, com comentários didáticos linha a linha:

```
// Arquivo: src/agt/sample_agent.asl

!start.                           ← objetivo inicial (disparado ao criar o agente)

+!start : true                    ← plano para o objetivo !start, contexto sempre verdadeiro
    <- .print("hello world.");    ← ação interna: imprime no console
       .date(Y,M,D);              ← ação interna: obtém data atual, liga variáveis Y, M, D
       +started(Y,M,D,H,Min,Sec). ← adiciona crença started/6 ao belief base
```

Explique o que cada linha faz e por que é importante.

---

### Parte 4 — Mini-quiz de verificação ✅

Faça **3 perguntas** curtas e diretas para verificar o entendimento. As perguntas devem ser sobre:
1. Um conceito declarativo ("o que é X?")
2. Um trecho de código ("o que este plano faz?")
3. Uma aplicação prática ("como você faria Y?")

Peça que o aluno responda **antes** de usar `/exercicio`. Aguarde as respostas.

Quando o aluno responder, avalie cada resposta:
- ✅ Certo — confirme e reforce com 1 frase complementar
- ⚠️ Parcialmente certo — corrija o ponto que faltou sem revelar mais do que necessário
- ❌ Errado — dê uma dica socrática e peça para tentar novamente

Após o quiz (mínimo 2/3 corretas), exiba:

```
---
Aula do Módulo [N] concluída ✅

Próximo passo: use `/exercicio [N] intro` para praticar o que aprendeu.
Ou pergunte qualquer dúvida antes de praticar.
---
```

---

> **Responda sempre em português do Brasil.**
> **Não entregue exercícios práticos antes de o aluno completar o mini-quiz.**
> **Base tudo no conteúdo de `doc/modulo-N.md` e no código real do `src/`.**
