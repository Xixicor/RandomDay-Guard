<a id="glossary"></a>
# Glossário

> **Fonte canônica em inglês:** [GLOSSARY.md](../../GLOSSARY.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


| Termo | Significado simples | Significado técnico exato |
|---|---|---|
| Log ativo | O log atual do servidor usado para novas evidências. | Obrigatório `active_log` fonte; legibilidade mais linhagem atual são necessárias para a conclusão da rota. |
| ID de inicialização | Início de um processo de watchdog. | Identificador de tempo de execução atual usado para rejeitar inicialização anterior errors/reports. |
| ID de época | Um intervalo de continuidade do servidor. | Identificador que abrange o tempo de execução normal até que a lógica de continuidade inicie outra época. |
| ID da pesquisa | Uma oportunidade de pesquisa limitada. | Campo de ciclo monotônico positivo; zero/missing não é possível completar uma rota. |
| Atualidade da fonte | Se a origem atual e a linhagem de pesquisa concordam. | `fresh_current_poll` ou `stale_or_unproven` com carimbos de data e hora e status de registro ativo. |
| Contabilidade de origem | Inventário de disponibilidade e limites de evidências. | `randomdayguard.source-accounting/v1` com oito classes de origem e current/historical escopo. |
| `available` | Uma fonte foi encontrada e lida. | Status da fonte do terminal com `available=true`, `readable=true`. |
| `expected_empty` | Uma fonte opcional foi verificada e legitimamente absent/empty. | Status da fonte legível pelo terminal; nunca fabrica um assunto. |
| `partial` | Trabalho limitado tem resultados úteis, mas incompletos. | status não terminal source/accounting; retoma o trabalhador proprietário. |
| `deferred` | O trabalho está intencionalmente pendente. | Status de origem não terminal; não é um erro ou conclusão. |
| `unavailable` | A fonte não pode ser usada no momento. | Lacuna no terminal; uma lacuna de fonte obrigatória torna a contabilidade indisponível. |
| `malformed` | Uma fonte existe, mas é estruturalmente inválida. | Lacuna de terminal preserva detalhes de validação e fecha gravações dependentes. |
| `permission_denied` | O sistema operacional rejeitou explicitamente o acesso. | Lacuna de terminal distinta de missing/unavailable. |
| `error` | Uma operação limitada falhou inesperadamente. | Falha no terminal que requer a recuperação indicada; nenhum detalhe secreto pertence aos relatórios públicos. |
| `complete` | Todas as fontes contabilizadas são terminais sem lacunas. | Status de contabilidade de origem de nível superior. |
| `complete_with_gaps` | As evidências atuais exigidas funcionam; permanecem lacunas terminais opcionais. | Status contábil de nível superior; as rotas ainda aplicam seus próprios requisitos. |
| `full` | Uma rota concluída com seu contrato não vazio obrigatório. | Enum de prova de rota com saídas de ciclo de corrente concluídas. |
| `limited_expected_empty` | Uma rota concluída e não encontrada qualificada subject/failure. | Enum de prova de rota com `completed=true`, `expected_empty=true`. |
| `missing` | A prova de conclusão da rota está ausente ou falhou. | Enum de prova de rota com `completed=false`; nunca está qualificado para caixa de saída. |
| Relatório estruturado | Saída de rota legível por máquina. | `<route>_latest.json` usando `randomdayguard.report/v1`. |
| Relatório traduzido | Renderização legível da mesma rota. | `<route>_latest.txt` com ordem fixa de referências observadas até a fonte. |
| Prova de rota | Registro de conclusão de rota cruzada. | `route_proof.json` vinculação version/boot/epoch/poll/freshness/output caminhos. |
| Evidências atuais | Observação pertencente ao ciclo ativo. | Escopo `current`; não reconstruído a partir do antigo filenames/reports. |
| Evidência histórica | Contexto retido de ciclos anteriores ou verificação lenta. | Escopo `historical`; pode informar a avaliação, mas não pode reivindicar a presença atual. |
| Somente revisão | Produzir evidências de revisão sem Admin.ini gravações reais. | Padrão `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Verificação de segurança da lista de banimentos | Uma pergunta que o Guard deve responder antes que ela possa mudar `Admin.ini`. | Ele deve confirmar a conta e a pontuação, excluir contas confiáveis e duplicatas, verificar um backup, detectar alterações externas, salvar a atualização pretendida e verificar ou restaurar com segurança o arquivo completo. |
| Caixa de saída local | Transferência opcional de notificação independente do provedor. | JSON arquivos com `delivery_backend="none"` e `delivery_attempted=false`. |
| Linha de base | Snapshot de contexto de arquivo salvo limitado e concluído. | Manifest/object/world estado reutilizado somente quando compatível e atualizado o suficiente. |
| Ponto de verificação | Retomar posição para trabalho de verificação incompleta. | `scan_checkpoint.json`; a exclusão não é a recuperação padrão. |
| Índice reconstruível | Resumo que pode ser regenerado. | Daily/weekly/forensic/final saída de revisão; a evidência da fonte permanece oficial. |
| Limite de evidências | Limite sobre o que uma fonte pode suportar. | `does_not_prove`explícitas, incógnitas, força de identidade e regras de escopo. |

As definições canônicas para esquemas estão em [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md); os termos de configuração estão no [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURA%C3%87%C3%83O.md).
