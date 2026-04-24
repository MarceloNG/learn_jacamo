---
description: Gera um exercício de JaCaMo para o módulo e nível informados. Uso: /exercicio [módulo 0-8] [intro|consolidação|desafio]
---

Leia os seguintes arquivos antes de gerar o exercício:
- `ROADMAP.md` (seção do módulo solicitado)
- `PROGRESS.md` (para saber o contexto do aluno)
- `src/agt/sample_agent.asl`
- `src/env/example/Counter.java`
- `learn_jacamo.jcm`

---

Gere **um exercício** de JaCaMo para o módulo e nível indicados pelo usuário, usando o formato abaixo. Se o módulo ou nível não forem especificados, pergunte antes de continuar.

---

## Formato obrigatório do exercício

```
## Exercício — Módulo [N]: [Nome do módulo] | Nível: [intro / consolidação / desafio]

### Contexto
[1–2 parágrafos situando o exercício no projeto learn_jacamo. Referencie o código real
do src/ — por exemplo, o agente `bob` em sample_agent.asl ou o artefato Counter.java.]

### O que fazer
[Enunciado objetivo. Liste os requisitos numerados. Seja específico sobre o comportamento esperado.]

### Arquivo(s) a modificar
- `src/agt/[arquivo].asl` (ou .java / .jcm conforme o módulo)

### Critérios de aceite
- [ ] Critério 1 — [comportamento observável esperado]
- [ ] Critério 2 — [comportamento observável esperado]
- [ ] Critério 3 — [comportamento observável esperado]

### Como testar
```bash
./gradlew -q --console=plain
```
[O que observar na saída do terminal ou nos inspetores:]
- `http://localhost:3272` → Mind Inspector — crenças e intenções do agente
- `http://localhost:3273` → Workspace Inspector — propriedades do artefato
- `http://localhost:3271` → Organisation Inspector — grupos e papéis

<details>
<summary>💡 Dica (clique para revelar)</summary>

[Uma dica que aponta na direção certa sem entregar a solução. Sugira qual conceito do ROADMAP.md rever.]

</details>
```

---

## Diretrizes por nível

- **intro:** um único conceito novo, estrutura parcial fornecida, solução de 3–10 linhas
- **consolidação:** combina 2+ conceitos do módulo, solução de 10–30 linhas, sem estrutura
- **desafio:** integra conceitos de módulos anteriores, enunciado aberto, sem dicas extras

---

> **Responda sempre em português do Brasil.**
> **O exercício deve poder ser executado com `./gradlew -q --console=plain`.**
> **Nunca forneça a solução junto com o enunciado.**
