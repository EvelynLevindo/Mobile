# EcoTrack - Documentação de Requisitos
#### Protótipagem: https://www.figma.com/design/bSgyl1oESikSfYzvTCfGWd/Sem-t%C3%ADtulo?node-id=0-1&t=jnZRfGAutvR80gGq-1

Este documento apresenta a especificação de requisitos para o projeto EcoTrack, um aplicativo desenvolvido em Flutter voltado para a gestão personalizada de hábitos sustentáveis.

---

## 1. Introdução

### 1.1 Propósito
O propósito deste documento é definir os requisitos funcionais e não funcionais do aplicativo EcoTrack, em sua implementação baseada no padrão de arquitetura MVP (model, view, provider).

### 1.2 Escopo do Sistema
O EcoTrack é um aplicativo que permite ao usuário criar seus próprios hábitos sustentáveis. Diferente de listas estáticas, o app oferece a adição, edição, remoção e acompanhamento de metas ambientais personalizadas, visualizando o impacto através de um dashboard dinâmico.

---

## 2. Descrição Geral

### 2.1 Perspectiva do Produto
O aplicativo é um protótipo funcional independente, focado em simplicidade técnica e alto desempenho. Ele utiliza o pacote Provider para gerenciamento de estado.

### 2.2 Funções do Produto
- **CRUD Completo de Hábitos:** Criação, leitura, edição e exclusão de hábitos.
- **Gestão de Hábitos:** Alternância de estados entre "Pendente" e "Concluído" (com função de desfazer).
- **Dashboard:** Métricas em tempo real sobre pontuação acumulada e metas.
- **Customização da Interface:** Tema claro e escuro.

### 2.3 Implementações
- **Framework:** Flutter (Dart).
- **Estrutura Organizada de Arquivos:** Organização em pastas model, view e provider.
- **Gerenciamento de Estado:** Provider (ChangeNotifier).
- **Identificadores:** Geração de IDs únicos baseada em timestamp (millisecondsSinceEpoch).

---

## 3. Requisitos do Sistema

### 3.1 Requisitos Funcionais (RF)

| ID | Nome | Descrição |
|:---|:---|:---|
| **RF-01** | Tela Inicial | Exibe texto sobre a importância da ação humana no meio ambiente e botão de acesso ao sistema. |
| **RF-02** | Adição de Hábitos | Permite a adição de título e descrição para hábitos sustentáveis criados pelo usuário. |
| **RF-03** | Edição de Dados | Possibilita a alteração de textos de hábitos já cadastrados via modal. |
| **RF-04** | Exclusão de Itens | Permite a remoção definitiva de hábitos de qualquer uma das listas. |
| **RF-05** | Transição de Estado | Move itens entre as abas "Pendentes" e "Concluídos" através de botões de ação rápida. |
| **RF-06** | Dashboard Dinâmico | Exibe via GridView: total de concluídos, pendentes, pontuação verde e meta semanal. |
| **RF-07** | Menu | Implementa navegação entre as visões principais via BottomNavigationBar e Drawer. |
| **RF-08** | Alternância de Tema | Disponibiliza um switch no menu lateral para troca entre modo claro e escuro. |

### 3.2 Requisitos Não Funcionais (RNF)

| ID | Nome | Descrição |
|:---|:---|:---|
| **RNF-01** | Reatividade | A interface deve ser atualizada em tempo real ao disparar o `notifyListeners()` no Provider. |
| **RNF-02** | Organização de Código | Segue rigorosamente a separação entre lógica (Provider) e UI (Views). |
| **RNF-03** | Coerência Visual | O layout respeita os wireframes de média fidelidade. |

---

## 4. Estrutura de Navegação e Interface

### 4.1 Hierarquia de Telas
1.  **HomeView:** Tela de onboarding com mensagem sobre sustentabilidade.
2.  **MainLayoutView:** Estrutura base que contém a `AppBar`, o `Drawer` e a `BottomNavigationBar`.
3.  **HabitoView (TabBarView):**
    * **Aba 1 (Pendentes):** `ListView` com botões de concluir, editar e excluir.
    * **Aba 2 (Concluídos):** `ListView` com opção de retornar o hábito para pendente.
4.  **DashboardView:** Painel de indicadores exibidos em um `GridView` de 2 colunas.

### 4.2 Componentes de Interface Utilizados
* **Scaffold:** Estrutura base de todas as telas.
* **Drawer:** Menu lateral para configurações de tema.
* **BottomNavigationBar:** Navegação entre lista de hábitos e estatísticas.
* **ModalBottomSheet:** Interface flutuante para criação e edição de hábitos.

---

## 5. Especificação Técnica (Provider)

A classe EcoProvider é o núcleo da aplicação, sendo responsável por:
-   **Manutenção da Lista:** Armazenar objetos da classe Habito.
-   **Cálculos de Impacto:** Processar a pontuação verde (10 pontos por hábito concluído).
-   **Estado Global:** Controlar o índice da tela ativa e a preferência de tema do usuário.

---

## 6. Estrutura do Projeto (File System)

```text
lib/
├── model/      # Classe Habito (id, titulo, descricao, isConcluido)
├── provider/   # EcoProvider (Gerenciamento de Estado e Lógica CRUD)
├── view/       # Telas: HomeView, MainLayoutView, HabitsView e DashboardView
└── main.dart    # Configuração do MultiProvider, MaterialApp e Temas
```