# RandomDayGuard em português do Brasil

> [!IMPORTANT]
> ## Status do projeto — testes do RandomDay concluídos
>
> A operação de testes do RandomDay foi concluída, e o servidor público de testes será fechado em breve.
>
> Durante essa operação, RandomDay e RandomDayGuard funcionaram juntos em rotações repetidas de perfis, reinicializações normais e interrompidas do servidor, verificações de recuperação e reversão, integração com mods estendidos, coleta de evidências do servidor e análise dos relatórios do operador.
>
> Com isso, obtivemos o conhecimento que buscávamos: como perfis rotativos de sandbox se comportam durante ciclos de vida reais de um servidor dedicado; como o RandomDay interage com os mods estendidos compatíveis; e até que ponto o RandomDayGuard pode transformar as evidências gravadas pelo servidor em monitoramento útil e cauteloso, sem apresentar lacunas ou suposições como fatos.
>
> **Conjunto usado no servidor de testes:**
>
> - RandomDay build privada de desenvolvimento `v0.41.76`
> - RandomDayGuard build privada de desenvolvimento `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — uma extensão do DynamicSpawns pertencente ao RandomDay, não um mod distribuído separadamente
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - servidor dedicado do Abiotic Factor `1.4.0.27939`
>
> Os pacotes publicados atualmente continuam sendo RandomDay `v0.3.16-alpha` e RandomDayGuard `v0.4.12-alpha`.
>
> O desenvolvimento dos dois projetos está pausado por enquanto. As versões e a documentação existentes continuarão disponíveis, e talvez retornemos quando sentirmos novamente vontade de continuar o trabalho.
>
> Este conjunto documenta o que foi usado durante a operação; ele não é um requisito de versão mínima nem uma garantia de compatibilidade com versões posteriores do jogo, do loader ou dos mods. O último ciclo registrado formalmente usou Abiotic Factor `1.4.0.27939`.

**v0.4.12-alpha**

RandomDayGuard transforma evidências limitadas de um servidor dedicado de
Abiotic Factor em relatórios claros para o operador. Estado do servidor,
continuidade diária, atividade de jogadores, revisão de casos e falhas críticas
permanecem em rotas separadas.

## Instalar

Siga o [guia de instalação](INSTALA%C3%87%C3%83O.md). A pasta correta é
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
`write_admin_ini = false`. Consulte [Primeiros passos](COMECE_AQUI.md),
[Operações](MANUAL_DE_OPERA%C3%87%C3%95ES.md), [Configuração](PERFIS_DE_CONFIGURA%C3%87%C3%83O.md)
e [Solução de problemas](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md). A evidência estruturada é o
registro técnico; a tradução oferece a leitura humana.

Comandos, caminhos, chaves e estados permanecem em inglês para corresponder aos
arquivos reais.

## Versão alfa e dois caminhos de evidência

Esta é uma versão alfa. Os caminhos documentados de coleta, relatório e recuperação foram testados; compatibilidade, cobertura histórica e qualidade dos relatórios continuam sendo aprimoradas.

O caminho atual usa o log ativo, o estado atual de inicialização e agendamento e as sessões em andamento, podendo escrever relatórios atuais imediatamente. O caminho histórico verifica logs preservados, nomes de PlayerData, evidências e casos existentes em etapas limitadas.

`runtime/current/report_worker_status.json`

Compare `scan_cursor` e `last_progress_ts` em `runtime/current/report_worker_status.json` durante vários ciclos. Se avançarem, a varredura funciona. Se permanecerem iguais enquanto os relatórios atuais avançam, a varredura histórica está parada; os fatos atuais continuam úteis, mas conclusões que dependem do histórico antigo ficam limitadas.

[Troubleshooting](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md)

## Biblioteca de documentação completa

Todos os documentos públicos do Markdown estão disponíveis neste idioma com nomes de arquivos localizados.

- [Abra o índice de documentação localizada](DOCUMENTA%C3%87%C3%83O.md)
