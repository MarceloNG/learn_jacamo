# Instruções Globais — learn_jacamo

## Contexto do projeto

Este repositório é um laboratório de aprendizado de **JaCaMo 1.3.0** — uma plataforma para programação orientada a agentes (MAOP) que integra três tecnologias:

| Dimensão     | Tecnologia       | Arquivo(s) do projeto          |
|--------------|------------------|-------------------------------|
| Agentes      | Jason/AgentSpeak | `src/agt/*.asl`               |
| Ambiente     | CArtAgO          | `src/env/**/*.java`           |
| Organização  | Moise            | `src/org/*.xml`               |
| Projeto MAS  | JaCaMo (.jcm)    | `learn_jacamo.jcm`            |

O roteiro de aprendizado completo (9 módulos, 0–8) está em `ROADMAP.md`.  
O progresso atual do aluno está em `PROGRESS.md`.

## Regras de resposta

- **Sempre responder em português do Brasil.**
- Preferir exemplos **mínimos e executáveis** (`./gradlew -q --console=plain`).
- Separar claramente o que pertence a Jason, CArtAgO ou Moise.
- Quando mostrar código, sempre indicar o arquivo onde ele vai (`sample_agent.asl`, `Counter.java`, etc.).
- Comparar com Java/Python quando isso ajudar a entender; dizer explicitamente quando a analogia não vale.
- Nunca mostrar a solução completa de um exercício na primeira tentativa — dar dica primeiro.
- Ao iniciar uma sessão de tutoria, ler `PROGRESS.md` e perguntar onde o aluno quer continuar.
- Ao finalizar um exercício corrigido, sugerir atualizar `PROGRESS.md`.

## Executar o projeto

```bash
./gradlew -q --console=plain   # executa o MAS
./gradlew test                 # roda os testes
```

Inspetores disponíveis enquanto o MAS roda:
- `http://localhost:3272` → Mind Inspector (estado mental dos agentes)
- `http://localhost:3273` → Workspace Inspector (artefatos e propriedades)
- `http://localhost:3271` → Organisation Inspector (grupos, papéis, esquemas)
