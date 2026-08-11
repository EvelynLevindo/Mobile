# Projeto Biblioteca APP Json

## 1. Identificação do Projeto

- **Nome do Projeto:** Biblioteca App
- **Descrição:** Aplicativo móvel multiplataforma (Flutter) para gerenciamento de bibliotecas, com funcionalidades de CRUD (criar, ler, atualizar e deletar) para usuários, livros e empréstimos.

## 2. Propósito e Escopo

O sistema tem como objetivo digitalizar a simplificar a gestão de acervos bibliotecários. Ele permite o cadastro e controle de livros, usuários e empréstimos, oferecendo uma interface intuitiva para administradores. O escopo atual inclui operações básicas de gerenciamento, com dados persistidos em um Backend simulado via Json Server.

## 3. Requisitos Funcionais (RF)

| ID | Requisitos | Descrição |
| --- | --- | --- |
| RF01 | Gerenciar Livros | Listar, cadastrar, editar e excluir livros do acervo |
| RF02 |  Gerenciar Usuários | Listar, cadastrar, editar e excluir usuários do sistema |
| RF03 | Gerenciar Empréstimos de Livros | Visualizar e gerenciar empréstimos de livros |
| RF04 | Navegação | Interface co m navegação para abas (livros, empréstimos e usuários) |

## 4. Requisitos Não Funcionais (RFN)

| ID | Requisitos | Descrição |
| --- | --- | --- |
| RFN01 | Arquitetura | Baseada em camadas (Model, Service, Controller e View) |
| RFN02 | Persistência | Utilisa um arquivo db.json como fonte de dados acessando via APIREST |
| RFN03 | Tecnologia | Desenvolvimento em Flutter/Dart, com consumo de API via pacote HTTP |
| RFN04 | Comunicação | A comunicação com o Backend é feita através de requisições HTTP sincronas (GET, POST, PUT, DELETE) |

## 5. Endpoints da API (Backend)

| Método | Endpoints | Descrição |
| --- | --- | --- |
| GET | /users | Lista todos os usuários |
| GET | /users/{id} | Busca um usário por ID |
| POST | /users | Cria um novo usuário |
| PUT | /users{id} | Atualiza um usuário |
| DELETE | /users/{id} | Remove um usuário |
| GET | /books | Lista todos os livros |
| GET | /books/{id} | Busca um livro por ID |
| POST | /books | Cria um novo livro |
| PUT | /books/{id} | Atualiza um livro |
| DELETE | /books/{id} | Remove um livro |
| GET | /loans | Lista todos os empréstimos |
| POST | /loans | Registra um novo empréstimo |

## 6. Diagramas

### 6.1 Diagramas de Entidade Relacional (DER)

```mermaid
erDiagram 
        USUARIO {
            int id PK 
            string name 
            string email
        }

        BOOK {
            int id PK 
            string titulo
            string autor
            boolean avaliacao
        }

        LOAN {
            int id PK 
            int userId FK
            int bookId FK 
            date startDate 
            date dueDate
            boolean returned
        }

        USER ||--o{ LOAN : "do"
        BOOK ||--o{ LOAN : "is loan in"
```

### 6.2 Diagrama de Classe 

```mermaid
classDiagram
    class ApiService{
        <<static>>
        _String_baseURL
        +getList(String path) Future~List~
        +getOne (String path, String id) Future~Map~
        +post(String path, Map body) Future~Map~
        +put(String path, Map body, String id) Future~Map~
        +delete(String path, String id) Future~void~
    }

    class UserModel {

    }

    class BookModel {

    }

    class LoanModel {

    }

```