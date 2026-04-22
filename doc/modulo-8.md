# Módulo 8 — Projeto Final: Construindo algo seu

> **Tecnologia:** JaCaMo (Jason + CArtAgO + Moise) — integrado
> **Pré-requisito:** Módulos 0–7
> **Tempo estimado:** livre

---

## Por que este módulo importa

Você chegou até aqui. Agora a diferença entre "estudei JaCaMo" e "sei programar com JaCaMo" é construir algo do zero — sem seguir um roteiro pronto.

Um projeto final bem feito consolida três habilidades que só aparecem quando você projeta sem guia:
1. **Decisão de design:** quando usar mensagens, artefato ou organização?
2. **Decomposição de comportamento BDI:** como dividir um comportamento complexo em goals e planos?
3. **Integração das três dimensões:** como as três camadas se encaixam de forma coerente?

---

## Checklist de um MAS completo

Um projeto final de JaCaMo deve ter:

### Dimensão de agentes (Jason)
- [ ] Pelo menos **3 agentes** com comportamentos distintos (não apenas variações do mesmo)
- [ ] Uso de **crenças** para representar o estado interno de cada agente
- [ ] Uso de **goals** pró-ativos (iniciados pelo agente) e reativos (disparados por eventos)
- [ ] Planos com **contexto de guarda** — diferentes planos para diferentes situações
- [ ] Tratamento de **falhas** com planos `-!objetivo`
- [ ] Pelo menos um uso de **gestão de intenções** (`.desire`, `.drop_desire`, `.suspend`)

### Dimensão de ambiente (CArtAgO)
- [ ] Pelo menos **1 artefato** com estado compartilhado
- [ ] **Propriedades observáveis** que agentes percebem automaticamente
- [ ] **Operações** que agentes invocam para agir no ambiente
- [ ] Pelo menos um **sinal** emitido pelo artefato para coordenar reações

### Dimensão de organização (Moise)
- [ ] **Grupos e papéis** — agentes identificados por papel, não nome
- [ ] **Scheme** com ao menos um objetivo coletivo decomposto em missões
- [ ] **Normas** — pelo menos uma obrigação ligada a um papel
- [ ] Agentes com `org-obedient.asl` ou planos próprios para cumprir obrigações

### Coordenação mista
- [ ] Pelo menos um exemplo de coordenação **por mensagem**
- [ ] Pelo menos um exemplo de coordenação **por artefato**
- [ ] Pelo menos um exemplo de coordenação **por organização**

### Qualidade
- [ ] Planos com **labels** (`@nome_do_plano`)
- [ ] Sem hardcode de nomes de agentes — usa papéis
- [ ] Projeto executa com `./gradlew -q --console=plain` sem erros
- [ ] Pelo menos 1 **teste** em `src/test/`

---

## Ideias de projetos

| Projeto | Complexidade | Conceitos em destaque |
|---------|-------------|----------------------|
| Sistema de estoque com fornecedores e compradores | Média | Artefatos, mensagens, BDI |
| Sala de reunião com agenda compartilhada | Média | Artefatos, organização, normas |
| Time de robôs de limpeza colaborativos | Alta | BDI avançado, gestão de intenções |
| Mercado de ações simulado | Alta | Todas as três dimensões |
| Sistema de monitoramento com alertas | Média | Reatividade, artefatos, sinais |
| Jogo de turnos multi-jogador (bot vs bot) | Alta | Coordenação, gestão de intenções |
| Sistema de entrega com múltiplos entregadores | Alta | Organização, artefato de mapa |

---

## Como projetar um MAS do zero

Siga estas etapas antes de escrever código:

### 1. Identifique os agentes e seus papéis
- Quem são os participantes do sistema?
- O que cada um sabe (crenças), quer (goals) e faz (planos)?
- Como eles se diferenciam entre si?

### 2. Identifique o estado compartilhado
- O que todos precisam ver/modificar?
- Isso vira um artefato CArtAgO
- Quais operações? Quais propriedades observáveis? Quais sinais?

### 3. Identifique as regras de coordenação
- Existe uma ordem obrigatória de passos? → Scheme em Moise
- Existe um papel responsável por iniciar/terminar? → Norma em Moise
- Existe comunicação direta e pontual? → Mensagem Jason

### 4. Escreva o `org.xml` antes do `.asl`
- Definir a organização primeiro clarifica quem faz o quê
- O código `.asl` fica mais simples quando a estrutura já está clara

### 5. Implemente agente por agente
- Comece com 1 agente funcionando completamente
- Adicione os demais progressivamente
- Use o Mind Inspector para verificar cada crença e intention

---

## Estrutura de arquivos sugerida

```
meu_projeto/
├── meu_projeto.jcm
├── src/
│   ├── agt/
│   │   ├── agente_a.asl
│   │   ├── agente_b.asl
│   │   └── agente_c.asl
│   ├── env/
│   │   └── meu_pacote/
│   │       └── MeuArtefato.java
│   └── org/
│       └── organizacao.xml
├── src/test/
│   ├── tests.jcm
│   └── agt/
│       └── test_agente.asl
└── doc/
    └── design.md   ← descreva suas decisões de design aqui
```

---

## Referências de arquitetura e exemplos completos

- [House Building — exemplo com as 3 dimensões](https://github.com/jacamo-lang/jacamo/tree/main/examples/house-building)
- [Writing Paper — coordenação organizacional](https://github.com/jacamo-lang/jacamo/tree/main/examples/writing-paper)
- [Auction — coordenação nas 3 versões](https://github.com/jacamo-lang/jacamo/tree/main/examples/auction)
- [JaCaMo — todos os exemplos oficiais](https://github.com/jacamo-lang/jacamo/tree/main/examples)
- [Padrões de design em Jason](https://jason-lang.github.io/jason/tech/patterns.html)

---

## Como apresentar o projeto

Ao usar `/corrigir-exercicio` com seu projeto final, forneça:

1. **Descrição do sistema** — o que ele faz e qual problema resolve
2. **Decisões de design** — por que escolheu cada abordagem de coordenação
3. **O código** — `.jcm`, `.asl`, `.java`, `.xml`
4. **O que funciona** — o que você já testou e validou
5. **O que não funciona** — onde você está travado (se for o caso)

O tutor avaliará pela rubrica completa: corretude, sintaxe, estrutura e idioms JaCaMo.

---

## Parabéns

Se você chegou até aqui com um projeto funcionando, você:

- Entende BDI na prática, não só na teoria
- Sabe quando usar cada uma das três dimensões de JaCaMo
- Consegue depurar um MAS usando as ferramentas certas
- Tem um projeto real para mostrar e evoluir

> Use `/proximo-passo 8` no chat para o tutor avaliar seu projeto e sugerir o que fazer a seguir.
