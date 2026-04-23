## Módulo atual

- **Módulo:** 1 — Estrutura do projeto JaCaMo
- **Status:** Aula concluída ✅ — aguardando exercício intro
- **Anterior:** Módulo 0 — ✅ Concluído

## Histórico de exercícios

| Módulo | Nível         | Exercício                                                       | Status               | Data       |
|--------|---------------|-----------------------------------------------------------------|----------------------|------------|
| 0      | intro         | Declarar `modulo_atual(0)` e imprimir o valor via `+!start`     | ✅ Concluído          | 22/04/2026 |
| 0      | consolidação  | BDI completo: `humor(mau)→bom` com gatilho de crença `+humor(bom)` | ✅ Aprovado c/ ressalvas | 22/04/2026 |
| 0      | conceitual    | Perguntas de auto-verificação BDI + dimensões + `focus`         | ✅ Q1 e Q2 corretas; Q3 parcial (percept→crença não articulado) | 23/04/2026 |
| 1      | conceitual    | Quiz da aula: instâncias independentes, focus, beliefs iniciais | ✅ 3/3 corretas                                                  | 23/04/2026 |

## Observações do tutor

**Módulo 0 — consolidação (22/04/2026)**
- Ponto de atenção: operador `-+X` — o argumento é o **destino**, não a origem
- Ponto de atenção: distinção entre `+!meta` (gatilho de meta) e `+crença(X)` (gatilho de crença)
- Ponto de atenção: contexto de guarda usa `not crença(X)` para testar ausência; `-crença(X)` só vale no corpo do plano

**Módulo 0 — perguntas de auto-verificação (23/04/2026)**
- Q1 (Belief vs Intention): ✅ conceito correto, especialmente distinção Desire vs Intention; faltou exemplo cotidiano explícito
- Q2 (separação em dimensões): ✅ correto — separação de responsabilidades, independência, processos distribuídos
- Q3 (focus: w.c1): ⚠️ parcialmente correto — identificou percepção do artefato, mas não articulou que sem `focus` os percepts (ex: `count(N)`) não viram crenças no belief base
- Próximo passo recomendado: exercício intro do Módulo 1 (estrutura do projeto `.jcm`)

**Módulo 1 — quiz da aula (23/04/2026)**
- Q1 (instâncias independentes): ✅ correto — `.asl` é tipo, cada declaração cria objeto distinto com belief base próprio
- Q2 (sem focus): ✅ correto — percepts não viram crenças; agente não percebe o artefato
- Q3 (beliefs iniciais): ✅ correto — `beliefs: papel(supervisora)` dentro do bloco `agent`; implementado e executado em `src/ex/mod1-ex1.jcm`
- Próximo passo recomendado: exercício intro do Módulo 1