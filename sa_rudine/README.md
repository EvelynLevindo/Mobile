# App de Treinos Físicos Personalizados

Este aplicativo foi desenvolvido em Flutter com o objetivo de permitir que os usuários criem, gerenciem e personalizem suas rotinas de treino físico. Os dados são persistidos localmente utilizando SQLite.

## Como Executar o Projeto

1. **Pré-requisitos:**
   - Flutter SDK instalado (versão 3.x ou superior).
   - Emulador Android/iOS configurado ou dispositivo físico conectado.
2. **Instalação:**
   - Clone este repositório: `git clone [url_do_repositorio]`
   - Acesse a pasta do projeto: `cd workout_app`
   - Instale as dependências: `flutter pub get`
3. **Execução:**
   - Rode o aplicativo: `flutter run`

---

# Documentação de Requisitos - Padrão ISO/IEC 29148:2018

## 1. Introdução
### 1.1 Propósito
Este documento especifica os requisitos de software para o "App de Treinos Físicos Personalizados". Ele define as capacidades do sistema, interfaces de usuário e restrições de design para garantir o desenvolvimento adequado do aplicativo mobile utilizando a framework Flutter.

### 1.2 Escopo
O aplicativo permite que entusiastas de atividades físicas registrem e acompanhem suas rotinas de treino de forma autônoma e offline. O sistema gerenciará a criação de rotinas (com metas definidas) e a alocação de múltiplos exercícios (com métricas de séries, repetições e carga) para cada rotina. 

## 2. Referências
- Documentação Oficial do Flutter: https://flutter.dev/docs
- Especificação SQLite (Pacote `sqflite`): https://pub.dev/packages/sqflite
- Norma ISO/IEC 29148:2018 - Systems and software engineering — Life cycle processes — Requirements engineering.

## 3. Especificação de Requisitos

### 3.1 Requisitos Funcionais (RF)
* **RF01 - Cadastro de Rotina:** O sistema deve permitir que o usuário cadastre uma nova rotina informando obrigatoriamente um "Nome" e um "Objetivo".
* **RF02 - Visualização de Rotinas:** O sistema deve listar todas as rotinas previamente cadastradas na tela inicial.
* **RF03 - Detalhamento da Rotina:** O sistema deve exibir os detalhes de uma rotina selecionada, incluindo a lista de exercícios vinculados a ela.
* **RF04 - Adição de Exercícios:** O sistema deve permitir a inclusão de exercícios em uma rotina, exigindo os campos: Nome do Exercício, Número de Séries, Repetições, Carga (peso) e Tipo.
* **RF05 - Persistência de Dados:** O sistema deve salvar todas as rotinas e exercícios no banco de dados local (SQLite) para que não sejam perdidos ao fechar o app.

### 3.2 Requisitos Não-Funcionais (RNF)
* **RNF01 - Usabilidade:** A interface deve seguir as diretrizes do Material Design, fornecendo feedback imediato ao usuário (ex: Snackbars para sucesso/erro e validação de formulários).
* **RNF02 - Desempenho:** As operações de leitura e gravação no banco de dados devem ocorrer de forma assíncrona para não bloquear a interface de usuário (UI thread).
* **RNF03 - Manutenibilidade:** O código-fonte deve estar estruturado em camadas claras (Models, Views/Screens, Controllers, Database) aplicando princípios de Orientação a Objetos.

### 3.3 Requisitos de Dados e Lógica de Negócios
* **RN01 - Integridade Relacional:** Quando uma rotina é acessada, apenas os exercícios com a correspondente `routineId` devem ser carregados e apresentados.
* **RN02 - Tipagem e Validação:** Os campos numéricos (Séries, Repetições, Carga) devem aceitar exclusivamente *inputs* numéricos. O envio de formulários vazios deve ser bloqueado, acionando mensagens de erro.