<a id="detection-signals"></a>
# Sinais de detecção

> **Fonte canônica em inglês:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Os sinais são entradas de revisão, não acusações automáticas.

<a id="signal-table"></a>
## Tabela de sinais

| Sinal | Significado | Mais forte quando... | Não é suficiente por si só |
|---|---|---|---|
| Identidade de login | Mapeia o nome para o ID da conta | ConnectID está presente | Ban |
| Lança limpa | Encerramento normal da sessão | Entrar e sair da partida | Suspeita |
| Reconexão rápida | Churn/probing contexto | Repete rapidamente | Ban |
| Desconexão incorreta | A sessão não foi fechada corretamente | Repete ou sobrepõe falhas | Ban |
| Sobreposição de falhas | Conta ativa perto da falha | A mesma conta se repete | Ban |
| Retorno pós-travamento | A conta retorna após reinicialização | Repete-se entre épocas | Banimento por um evento |
| Buzz de aviso | Janela de aviso do servidor | Sobrepõe sessões mapeadas | Banimento por um burst |
| Toque salvo do ator | Contexto de salvamento mundial | Correlaciona-se com sessões | Prova de use/theft |
| delta de objeto | World/class alteração | Correlaciona-se com sessões | Banimento apenas da contagem |
| Caso de ataque | Cluster de várias contas | Conta central repete | Banir em massa todas as contas |

<a id="login-identity"></a>
## Identidade de login

Melhor fonte:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Use-o para mapear:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Reconexão rápida

Padrão:

```text
join -> leave -> join -> leave -> join
```

Use para revisão quando repetido.

Segurança:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Sobreposição de falha e retorno pós-travamento

Padrão:

```text
account active before crash
server restarts
same account returns quickly
```

Use para revisão quando repetido entre épocas.

Segurança:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Rajadas de aviso

Exemplos:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Use como contexto até ser vinculado a sessões e limites mapeados.

<a id="actor-save-touch"></a>
## Toque salvo do ator

Significado:

```text
The server evidence referenced a class or actor.
```

Sem significado:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Casos de ataque

Um caso de ataque agrupa contas por tempo e janelas compartilhadas.

Regra:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Documentos relacionados

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](PADR%C3%95ES_E_RESILI%C3%8ANCIA_DE_ATORES_MAL-INTENCIONADOS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
