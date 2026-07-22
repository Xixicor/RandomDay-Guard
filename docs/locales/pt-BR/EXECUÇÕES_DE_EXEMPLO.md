<a id="worked-operation-examples"></a>
# Exemplos de operações resolvidas

> **Fonte canônica em inglês:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Esses exemplos usam valores inventados para explicar transições de estado esperadas; eles não são compatibilidade ao vivo ou evidência do jogador.

<a id="successful-current-cycle"></a>
## Ciclo atual bem-sucedido

Entradas: log ativo legível, version/boot/epoch, `poll_id=41`, pesquisa atual concluída, raízes graváveis accounting/history/report, sem política de bloqueio de varredura lenta.

Esperado:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Toda rota habilitada tem JSON/TXT saída e a mesma linhagem em `route_proof.json`. O status da rota depende de seus próprios assuntos, não de uma mensagem genérica de sucesso.

<a id="expected-empty-player-and-case-routes"></a>
## Rotas de caso e player vazios esperados

Entradas: a prova do ciclo atual está completa; nenhuma linha de jogador atual ou mantida; nenhum caso retido e nenhuma conta REVIEW/BAN-ELIGIBLE atual.

Esperado:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Os relatórios traduzidos dizem que nenhum sujeito vinculado elegível foi observado. Eles também dizem que isso não prova que ninguém tenha se conectado ou que não falte nenhum contexto. Nenhum espaço reservado player/case é criado.

<a id="partial-bounded-scan"></a>
## Verificação limitada parcial

Entradas: atual atual log/poll; `scan_checkpoint.json` ou `scan_progress.json` existe; a verificação está incompleta; default `slow_world_scan_blocks_current_reports=false`.

Esperado:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Definir `slow_world_scan_blocks_current_reports=true` somente quando o operador desejar que essa fonte lenta opcional bloqueie os relatórios atuais. A recuperação serve para permitir que o trabalho de verificação seja retomado, não para excluir o ponto de verificação.

<a id="missing-current-cycle-proof"></a>
## Prova de ciclo atual ausente

Entradas: log ativo indisponível, `poll_id=0`, ou boot/epoch/last-poll linhagem ausente.

Esperado:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

O envelope suprimido é um registro de auditoria, não uma entrega na fila. Os registros finais antigos permanecem apenas históricos. Repare o primeiro campo lineage/source ausente e gere um ciclo mais novo.

<a id="malformed-optional-adminini-source"></a>
## Fonte Admin.ini opcional malformada

Entradas: `Admin.ini` existe, mas falha na validação estrutural limpa.

Esperado:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Preservar o arquivo e restaurar um revisado formato limpo. Manter texto explicativo em evidência de tempo de execução; cada `Admin.ini` entrada banida permanece apenas `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Erro de sondagem de log ativo obrigatório

Entradas: o teste de log ativo obrigatório e limitado falha com um erro de leitura limpo.

Esperado:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` permanece na linha de origem com seus detalhes limitados. O relatório de nível superior usa `unavailable`, e a prova de rota permanece `missing` até que um ciclo atual mais recente comprove a origem necessária.

<a id="incompatible-or-stale-baseline"></a>
## Linha de base incompatível ou obsoleta

Entradas: package/source identidade alterada ou stale/incompatible linha de base manifest.

Esperado: validação ou status de tempo de execução registra a incompatibilidade; O estado de digitalização não reivindica a reutilização concluída. Preserve as evidências anteriores, inicie uma reconstrução explícita da linha de base e aguarde uma nova prova terminal. Uma reconstrução forçada sem um motivo registrado não é a recuperação padrão.

<a id="paired-report-write-failure"></a>
## Falha na gravação do relatório emparelhado

Entradas: JSON a gravação é bem-sucedida, mas TXT a gravação falha, ou o contrário.

Esperado:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

O melhor esforço do escritor reescreve ambos os irmãos para convergir em caso de falha. Um irmão bem-sucedido não pode permanecer como uma afirmação de sucesso. O detalhe de gravação limitado não cria um quinto valor de cobertura de nível superior.

<a id="route-proof-write-failure"></a>
## Falha de gravação à prova de rota

Entradas: pares de rotas foram gravados, mas `route_proof.json` não podem ser substituídos.

Esperado: todos os relatórios são reescritos `missing`, todos os resultados de notificação são `route_proof_write_failed`, e nenhum envelope é aceito. Uma rota configurada pode ter um `suppressed_current_cycle` envelope de auditoria com sinalizadores de entrega falsos. Repare a raiz de saída e gere novamente o mesmo ciclo atual.

<a id="review-only-enforcement-example"></a>
## Exemplo de aplicação somente para revisão

Configuração:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Esperado: pontuações, casos e recomendações podem ser escritos; `Admin.ini` permanece inalterado. Este é o padrão público.

<a id="approved-write-success-example"></a>
## Exemplo de sucesso de gravação aprovada

Somente um teste aprovado separadamente pode definir todas as três chaves de gravação. Ele também deve comprovar identidade numérica limpa, trust/moderator exclusão, elegibilidade de limite, validade Admin.ini path/parse, sucesso de backup, sucesso de gravação, igualdade de leitura e evidências específicas da conta.

Esperado:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

O exemplo bem-sucedido não permite a aplicação automática para outras contas.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback falha com reversão

Entradas: cada portão de pré-gravação passou; a gravação ou leitura de substituição falha; `rollback_on_readback_failure=true` e o backup verificado está disponível.

Esperado: evidência de falha registra o estágio e `rollback_success`; os Admin.ini bytes originais são restaurados e a conta não é relatada como aplicada com sucesso. Se a reversão também falhar, interrompa as gravações, preserve ambos files/evidence e recupere manualmente do backup.

<a id="local-outbox-example"></a>
## Exemplo de caixa de saída local

Entradas: notificação habilitada no modo `local_file_outbox`, rota habilitada, prova de rota concluída e `full` ou explicitamente permitida esperado-vazio.

Envelope esperado:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

Para missing/ineligible saída, o mesmo caminho pode conter `status=suppressed_current_cycle`, `completed_output=false` e `delivery_eligible=false`. Qualquer um dos arquivos prova apenas uma gravação local. Nenhum provedor, transporte, entrega ou recibo de leitura é empacotado ou inferido.

Consulte [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md), [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURA%C3%87%C3%83O.md) e [`TROUBLESHOOTING.md`](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md).
