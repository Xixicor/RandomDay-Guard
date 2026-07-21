# RandomDayGuard em português do Brasil

**v0.4.12-alpha**

RandomDayGuard transforma evidências limitadas de um servidor dedicado de
Abiotic Factor em relatórios claros para o operador. Estado do servidor,
continuidade diária, atividade de jogadores, revisão de casos e falhas críticas
permanecem em rotas separadas.

## Instalar

Siga o [guia de instalação](../../../INSTALL.md). A pasta correta é
`ue4ss/Mods/RandomDayGuard` e `mods.txt` deve conter `RandomDayGuard : 1`.
Evite instalações aninhadas e pastas `Scripts` duplicadas.

## Comprovar o primeiro relatório

Leia `runtime/current/startup_status.json`, depois
`runtime/final_logs/latest_dossier.json` e
`runtime/final_logs/route_proof.json`. Cada rota deve informar `full`,
`limited_expected_empty` ou `missing`. O resumo e a fonte citada precisam ser
do mesmo ciclo.

## Configurar e operar

Os padrões públicos são `review_only_mode = true`, `auto_ban = false` e
`write_admin_ini = false`. Consulte [Primeiros passos](../../START_HERE.md),
[Operações](../../OPERATIONS_PLAYBOOK.md), [Configuração](../../CONFIG_PROFILES.md)
e [Solução de problemas](../../TROUBLESHOOTING.md). A evidência estruturada é o
registro técnico; a tradução oferece a leitura humana.

Comandos, caminhos, chaves e estados permanecem em inglês para corresponder aos
arquivos reais.

## Versão alfa e dois caminhos de evidência

Esta é uma versão alfa. Os caminhos documentados de coleta, relatório e recuperação foram testados; compatibilidade, cobertura histórica e qualidade dos relatórios continuam sendo aprimoradas.

O caminho atual usa o log ativo, o estado atual de inicialização e agendamento e as sessões em andamento, podendo escrever relatórios atuais imediatamente. O caminho histórico verifica logs preservados, nomes de PlayerData, evidências e casos existentes em etapas limitadas.

`runtime/current/report_worker_status.json`

Compare `scan_cursor` e `last_progress_ts` em `runtime/current/report_worker_status.json` durante vários ciclos. Se avançarem, a varredura funciona. Se permanecerem iguais enquanto os relatórios atuais avançam, a varredura histórica está parada; os fatos atuais continuam úteis, mas conclusões que dependem do histórico antigo ficam limitadas.

[Troubleshooting](../../TROUBLESHOOTING.md)
