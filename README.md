# 💎 LightMine v1.2.5

**LightMine** é um agente de mineração solo de Bitcoin (SHA-256) projetado para ser extremamente leve, transparente e de fácil distribuição. O projeto foi desenvolvido com foco na experiência do usuário, permitindo que qualquer pessoa contribua para a rede Bitcoin sem comprometer a performance do seu computador no dia a dia.

## 🚀 Diferenciais do Projeto

- **Impacto Mínimo**: Configurado por padrão para utilizar apenas uma thread da CPU, garantindo que o computador continue rápido para tarefas comuns.
- **Operação Headless (Invisível)**: Utiliza uma ponte VBScript para rodar o processo de mineração em segundo plano, sem janelas de terminal abertas.
- **Persistência Inteligente**: Inicia automaticamente com o Windows através de um script otimizado na pasta de inicialização.
- **Instalador Profissional**: Desenvolvido com Inno Setup, conta com recuperação automática de dados de usuário e logs de instalação.
- **Mineração Solo**: Conectado à `public-pool.io`, focado no desafio de minerar blocos individuais.

## 📁 Estrutura do Repositório

- `/src`: Contém o motor de mineração (`LightMine.exe`).
- `LightMine_Setup.iss`: Script fonte do Inno Setup para gerar o instalador.
- `README.md`: Documentação do projeto.

## 🛠️ Como Compilar

1. Instale o [Inno Setup](https://jrsoftware.org/isinfo.php).
2. Abra o arquivo `LightMine_Setup.iss`.
3. Clique em "Compile".
4. O instalador `LightMine_Setup.exe` será gerado na mesma pasta.

## ⚙️ Funcionamento Técnico

Ao ser instalado, o LightMine:
1. Cria um diretório em `%ProgramData%\LightMine`.
2. Gera um arquivo `.bat` dinâmico com o nome de usuário (Worker ID) escolhido pelo instalador.
3. Cria um script `.vbs` no `Startup` do Windows que executa o minerador em modo oculto (Window Style 0).

---
*Projeto desenvolvido como parte do portfólio de engenharia de software e sistemas distribuídos.*
