# learn_jacamo

Projeto de aprendizado prático de **JaCaMo 1.3.0** — plataforma para programação orientada a agentes e multi-agentes.

## O que é JaCaMo?

JaCaMo integra três tecnologias em uma plataforma unificada:

| Tecnologia | Dimensão | Responsabilidade |
|-----------|----------|------------------|
| **Jason** | Agentes | Raciocínio BDI de cada agente |
| **CArtAgO** | Ambiente | Artefatos compartilhados e percepção |
| **Moise** | Organização | Papéis, normas e coordenação social |

## Como usar este repositório

Este projeto é um **laboratório vivo** — comece pela execução e evolua gradualmente seguindo o roteiro.

### Pré-requisitos

- Java 11+
- JaCaMo instalado: siga o [Getting Started oficial](https://jacamo-lang.github.io/getting-started)

### Configurar o Gradle Wrapper (primeira vez)

O `gradle-wrapper.jar` não está rastreado no git (arquivo binário). Restaure-o com:

```bash
# Opção 1: via Gradle (se instalado)
gradle wrapper --gradle-version 8.10

# Opção 2: via wget
wget -q "https://github.com/gradle/gradle/raw/v8.10.0/gradle/wrapper/gradle-wrapper.jar" \
     -O gradle/wrapper/gradle-wrapper.jar
```

### Executar o projeto

```bash
./gradlew -q --console=plain
```

Inspecione em tempo real:
- `http://localhost:3272` → Mind Inspector (crenças e planos dos agentes)
- `http://localhost:3273` → Workspace Inspector (artefatos de ambiente)
- `http://localhost:3271` → Organisation Inspector (grupos e normas)

### Executar os testes

```bash
./gradlew test
```

## Roteiro de aprendizado

Veja [ROADMAP.md](ROADMAP.md) para o plano de estudos completo com 9 módulos:

| Módulo | Tema |
|--------|------|
| 0 | Teoria: MAOP, BDI, e por que JaCaMo existe |
| 1 | Estrutura do projeto e primeiros passos |
| 2 | Agentes: Beliefs, Goals e Plans (Jason/AgentSpeak) |
| 3 | Ambiente: Artefatos e Workspaces (CArtAgO) |
| 4 | Organização: Grupos, Papéis e Esquemas (Moise) |
| 5 | Coordenação: as três dimensões comparadas |
| 6 | Exemplo avançado: Gold Miners |
| 7 | Debug, testes e boas práticas |
| 8 | Projeto final |

## Estrutura

```
learn_jacamo.jcm          ← ponto de entrada do MAS
src/
├── agt/
│   └── sample_agent.asl  ← agente BDI de exemplo
├── env/
│   └── example/
│       └── Counter.java  ← artefato CArtAgO de exemplo
└── org/
    └── org.xml           ← especificação Moise
```

## Referências

- [Site oficial JaCaMo](https://jacamo-lang.github.io/)
- [Getting Started](https://jacamo-lang.github.io/getting-started)
- [Documentação completa](https://jacamo-lang.github.io/doc)
