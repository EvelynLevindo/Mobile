================ 27/01 ================
# Descrição do Primeiro Dia de Aula
O objetivo principal da aula de hoje foi configurar o Git Hub com o VSCode.
Primeiro instalamos o Git Bash e colocando alguns comandos relacionados a nossa conta no Git Hub.
Depois, instalamos o VSCode e cadastrando nossa conta nele.
E por fim, utilizamos o terminal do VSCode para entrar em pastas (.cd \...\), crir pastas (mkdir), visualizar o que fizemos dentro da pasta (dir) e a criar um arquivo nulo (type nul > ... .md).

================ 03/02 ================
# Introdução ao desenvolvimento Modile
## Tipos de Desenvolvimento
- NATIVO
    * Android:
        + SDK: Android SDK.
        + IDE: Android Studio.
        + Linguagens: Kotlin e Java.
        + Ambientes: Mac, Win, Linux.
    * iOS:
        + SDK: Cocoa Touch.
        + IDE: Xcode.
        + Linguagens: Swift / Objectype-C
        + Ambientes: Mac.

- MULTIPLATAFORMA
    * React Native:
        + SDK: Node.JS.
        + IDE: VSCode.
        + Linguagens: JavaScript / TypeScript.
        + Ambientes: Mac, Win, Linux.
    
    * Flutter:
        + SDK: Flutter SDK
        + IDE: VSCode, Android Studio.
        + Linguagens: Dart.
        + Ambiente: Mac, Win, Linux.

## Preparação do Ambiente de Desenvolvimento
### Instalação do Flutter SDK
- Download do arquivo ZIP na página flutter.dev
- Inclusão do flutter na pasta C:\src
- Inclusão do flutter\bin nas variáveis da ambiente
- Teste o flutter --version

### Instalação do AndroidSDk
- Download so AndroidSDK - Command Line Tools
- Adicionar o Command-Line ao C:\src\AndroidSDK
- Adicionar o SDKManager as Variáveis de Ambiente
- Download dos pacotes
    - Emulator
    - Plataforms
    - Plataform-Tools
    - Build-Tools
- Adicionar ADB e o Emulador as Variáveis de Ambiente
- Criação da Imagem do Emulaor - via sdkmanager
- Build do Emulador - via sdkmanager

================ 24/02 ================
### Criação de Projetos e Códigos da Linha e Comando

- Criação de projetos
    - flutter create nome_do_app
        - flags
            - --empty : Cria um aplicativo "vazio"(hello world)
            - --platforms : Permite a seleção de plataforma de desenvolvimento
                -Exemplo: --platforms=android (a criação do projeto será somente para a plataforma android)
    - Exemplo de criação de uma plataforma android vazia
        - flutter create nome_do_app --empty --plataforms=android
        - OBS O nome do aplicativo tem que que ter todas as letras minúsculas e separação de palavras com "_".
    - flutter doctor
        - Permite a correção de pequenos prolemas no flutter e identificação dos paâmetros funcionais em relação as plataforsmas de desenvolvimento.
        - Sempre rodar o flutter doctor no começo do desenvolvimento.
    - flutter clean
        - Limpa o cachê da build (apaga o apk anterior).
    - flutter run -v
        - -v = Verbaliza o que está acontecendo, etapa por etapa.
        - Build do aplicativo (apk).
        