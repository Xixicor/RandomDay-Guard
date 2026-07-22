<a id="security-policy"></a>
# Política de segurança

> **Fonte canônica em inglês:** [SECURITY.md](../../../SECURITY.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


<a id="report-a-vulnerability-privately"></a>
## Informar uma vulnerabilidade de forma privada

Use [GitHub relatórios de vulnerabilidade privada](https://github.com/Xixicor/RandomDay-Guard/security/advisories/new) para enviar um relatório confidencial ao proprietário do repositório. Se esse formulário não estiver disponível, use o [perfil público do proprietárioGitHub](https://github.com/Xixicor) para solicitar um canal de contato privado sem incluir detalhes de vulnerabilidade.

Não abra um problema público contendo etapas de exploração, credenciais, caminhos de servidores privados, identificadores de jogadores, `Admin.ini`, dados salvos, URLs de webhook ou arquivos de evidências em tempo real.

<a id="include-useful-evidence"></a>
## Inclua evidências úteis

Forneça:

- a RandomDayGuard versão ou commit afetado;
- o componente afetado e o comportamento seguro esperado;
- etapas mínimas de reprodução usando acessórios higienizados;
- o impacto observado e se ele é repetível; e
- qualquer mitigação proposta que não exponha dados privados.

Não envie segredos reais. Substitua caminhos privados, identificadores de conta, nomes de host e tokens por espaços reservados claros, preservando a estrutura necessária para reproduzir o problema.

<a id="expect-review-first-handling"></a>
## Espere o tratamento da revisão primeiro

Um relatório é uma evidência para revisão do mantenedor, não para autorização para acessar um servidor, testar um alvo ativo, publicar detalhes de exploração ou enfraquecer padrões de falha fechada. O proprietário validará o escopo e coordenará qualquer divulgação por meio do relatório privado.
