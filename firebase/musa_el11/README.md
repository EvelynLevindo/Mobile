# Musa - Playlists Colaborativas
##### Wirefranme: https://stitch.withgoogle.com/projects/14342518136073450359

Aplicativo Flutter integrado ao Firebase (Auth e Firestore) e à API do Last.fm.

## Configuração
1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
2. Habilite a autenticação por **E-mail/Senha**.
3. Crie um banco de dados **Firestore** e copie o conteúdo de `firestore.rules` para a aba Regras.
4. Execute `flutterfire configure` na raiz do projeto para gerar o `firebase_options.dart`.
5. Obtenha uma API Key do Last.fm (https://www.last.fm/api) e insira em `lib/services/lastfm_service.dart`.

## Testes Requisitados
1. **Login/Cadastro:** Use e-mail e senha. Note a criação de um doc em `/users/{uid}`.
2. **Permissões:** Teste criar uma playlist e adicionar músicas. Entre com outra conta (colaborador convidado) e tente excluir a playlist (o botão sumirá na UI, mas testes diretos ao Firestore mostrarão falha de permissão de acordo com as `firestore.rules`).
3. **Colaboração em Tempo Real:** Conecte dois emuladores com contas diferentes. Quando o colaborador adicionar uma música da tela de busca, o StreamBuilder atualizará a UI do dono instantaneamente.