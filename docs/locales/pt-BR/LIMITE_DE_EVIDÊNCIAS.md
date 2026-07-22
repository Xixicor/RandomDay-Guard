<a id="evidence-boundary"></a>
# Limite de evidências

> **Fonte canônica em inglês:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use esta página para decidir o que RandomDayGuard pode relatar e o que ainda requer revisão humana.

<a id="core-rule"></a>
## Regra básica

RandomDayGuard registra observações limitadas de arquivos de propriedade do servidor. Ele deve identificar a origem, o escopo, o estado da coleção e os limites para cada conclusão material.

Evidências estruturadas são confiáveis. Um relatório traduzido explica as evidências; ele não pode adicionar fatos que estão ausentes do registro estruturado.

<a id="evidence-source-classes"></a>
## Classes de origem de evidências

| Classe de origem | Uso típico | Não prova por si só |
|---|---|---|
| `admin_ini` | Estado de administração existente e auditado write/readback contexto | Quem causou um incidente |
| `active_log` | Eventos server/session atuais visíveis no log ativo | Intenção, propriedade ou dano direto |
| `recent_backup_logs` | Contexto histórico do log | Ocorreu um evento atual |
| `playerdata_filenames` | Corroboração de que um identificador de conta limpo existe | Comportamento, culpa ou propriedade de identidade além do identificador exposto |
| `existing_cases` | Contexto de revisão anterior | Que uma interpretação anterior permanece correta |
| `existing_reports` | Resumos e decisões anteriores | Verdade atual sem corroboração atual |
| `existing_evidence` | Evidência histórica estruturada | Atividade atual |
| varredura limitada de salvamento mundial | Lenta world/class contexto | Ação, propriedade, roubo, duplicação ou dano do jogador |

Cada fonte registra availability/readability, contagem de arquivos, referências de origem, escopo atual ou histórico e um `does_not_prove` explícito. declaração.

<a id="source-states"></a>
## Estados da fonte

| Estado | Significado do operador |
|---|---|
| `available` | A fonte era legível e as evidências foram coletadas. |
| `expected_empty` | A fonte era legível e legitimamente não tinha nenhum registro correspondente. |
| `partial` | Algumas evidências foram coletadas; a cobertura está incompleta. |
| `deferred` | O trabalho vinculado foi adiado intencionalmente. |
| `unavailable` | A fonte não está presente neste ambiente. |
| `malformed` | A fonte existe, mas não pode ser analisada com segurança. |
| `permission_denied` | O watchdog não tem permissão de leitura. |
| `error` | A coleta falhou para outro registro. motivo. |

O vazio esperado é uma observação válida. Ela nunca deve ser convertida em um jogador, caso, incidente ou acusação fabricado.

<a id="current-versus-historical-evidence"></a>
## Evidência atual versus histórica

A evidência atual pertence à janela de coleta ativa ou época do servidor. A evidência histórica vem de registros, casos, relatórios, registros de evidências, backups ou linhas de base anteriores.

A evidência histórica pode fornecer contexto. Não pode preencher silenciosamente uma lacuna nas evidências atuais. Os relatórios devem rotular ambos os escopos e citar suas fontes separadamente.

<a id="corroboration-rule"></a>
## Regras de corroboração

Estes são contextos úteis, mas não são prova direta por si só:

- nomes de exibição ou similaridade de nomes;
- coincidência de tempo;
- desconectar ou reconectar a rotatividade;
- uma falha ou explosão de aviso;
- tokens de classe, caminho, ator, mapa ou contagem de objetos;
- filiação a um caso agrupado automaticamente;
- relatórios anteriores sem confirmação da fonte atual.

Faça não reivindicar culpa, intenção, trapaça, propriedade, roubo, duplicação, dano direto, uso direto de contêiner, ação direta de inventário, coordenadas exatas ao vivo, ping ao vivo ou comportamento em nível de memória sem evidências que exponham diretamente o fato.

<a id="truthful-report-language"></a>
## Linguagem de relatório verdadeira

Uso:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Evitar:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Leitura de relatório ordem

Todo relatório voltado ao público deve explicar:

1. Significado simples.
2. Por que isso é importante.
3. Prova técnica e referências de origem.
4. Próxima ação.
5. Limites, incógnitas e reivindicações não provadas.

<a id="related-docs"></a>
## Documentos relacionados

- [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
- [`BAN_ID_MAPPING.md`](MAPEAMENTO_DE_ID_DE_BANIMENTO.md)
- [`DETECTION_SIGNALS.md`](SINAIS_DE_DETEC%C3%87%C3%83O.md)
