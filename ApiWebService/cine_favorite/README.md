# CineFavorite

## Descrição
CineFavorite é um aplicativo acadêmico desenvolvido em Flutter que permite pesquisar filmes e séries através da API do TMDB (The Movie Database). Os usuários podem fazer login com um nome de usuário simples, salvar seus filmes e séries favoritos e atribuir notas (0 a 5) às suas escolhas. Todos os dados são persistidos diretamente em um banco de dados PostgreSQL.

## Tecnologias utilizadas
* Flutter
* Dart
* PostgreSQL
* TMDB API
* Pacote HTTP (consumo da API)
* Pacote Postgres (conexão direta com o banco de dados)

## Pré-requisitos
* [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
* [PostgreSQL](https://www.postgresql.org/download/) instalado e rodando localmente (ou em um servidor acessível).
* Chave de API do TMDB.

## Configuração do TMDB
1. Acesse [The Movie Database (TMDB)](https://www.themoviedb.org/) e crie uma conta gratuita.
2. Navegue até as configurações da sua conta e vá na aba "API".
3. Solicite uma chave de API para uso em Desenvolvimento/Estudo.
4. Anote a "API Key (v3 auth)".
5. **Atenção:** A chave nunca deve ser exposta no GitHub. Para configurar localmente, edite o arquivo `lib/config.dart` e substitua `SUA_API_KEY_AQUI` pela sua chave real. O arquivo `config.dart` está incluído no `.gitignore` por segurança.

## Configuração do PostgreSQL
1. Crie um banco de dados vazio no PostgreSQL chamado `cinefavorite`.
2. Execute o script `database.sql` fornecido na raiz deste projeto para criar as tabelas `users` e `favorites`.
3. Abra o arquivo `lib/config.dart` e preencha as variáveis `dbHost`, `dbPort`, `dbName`, `dbUser` e `dbPassword` com as credenciais do seu banco. 
> **Dica:** Se estiver usando o Emulador Android e o banco de dados estiver na sua própria máquina (localhost), utilize `10.0.2.2` como `dbHost`.

## Instalação e Execução
1. Clone o repositório ou baixe os arquivos.
2. Abra o terminal na pasta raiz do projeto.
3. Execute o comando para baixar as dependências:
   ```bash
   flutter pub get