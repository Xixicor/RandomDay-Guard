<a id="player-review-workflow"></a>
# Fluxo de trabalho de revisão do jogador

> **Fonte canônica em inglês:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use esta página para um jogador, conta ou caso. O objetivo é uma decisão de revisão reproduzível, não uma acusação automatizada.

<a id="quick-path"></a>
## Caminho rápido

1. Aberto `runtime/final_logs/player_activity_latest.json`.
2. Confirme o status da rota em `runtime/final_logs/route_proof.json`.
3. Identifique quais observações são atuais e quais são históricas.
4. Verifique a identidade citada e as referências de origem da sessão.
5. Revisão `case_review_latest.json` quando existir um caso correlacionado.
6. Registre incógnitas e `does_not_prove` antes de escolher uma ação.
7. Deixe a aplicação desativada, a menos que o portas de aplicação separadas são comprovadas.

<a id="1-confirm-route-proof"></a>
## 1. Confirme a prova de rota

Interprete a rota do jogador como:

| Status | Ação |
|---|---|
| `full` | Continue, enquanto ainda revisa os limites da fonte. |
| `limited_expected_empty` | Continue apenas com os assuntos realmente presentes; não invente um jogador ou caso perdido. |
| `missing` | Interrompa a decisão do jogador e solucione o problema da rota. |

Um agendador saudável não substitui a prova de rota.

<a id="2-establish-identity"></a>
## 2. Estabeleça a identidade

Prefira um identificador de conta limpo, corroborado por evidências de identidade expostas pelo servidor e, quando disponível, PlayerData nomes de arquivos. Mantenha a referência da fonte bruta.

Não aplique a partir de:

- apenas um nome de exibição;
- um nome visto em uma notificação ou painel de hospedagem;
- similaridade de tempo;
- uma identidade não mapeada ou de baixa confiança;
- um relatório histórico sem corroboração atual.

<a id="3-separate-current-from-historical"></a>
## 3. Separe o atual do histórico

A evidência atual descreve a janela de relatório ativa ou a época do servidor. A evidência histórica pode explicar um padrão, mas não pode preencher silenciosamente as lacunas na janela atual.

Registre ambos os escopos de forma independente:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Revise as observações e a interpretação

Leia estas seções do relatório com atenção:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Reabra as evidências estruturadas citadas para qualquer decisão material. Uma tradução é navegação e explicação, não novas evidências.

<a id="5-calibrate-the-decision"></a>
## 5. Calibrar a decisão

| Decisão | Usar quando |
|---|---|
| `INFO` | Observação normal ou de baixo contexto. |
| `WATCH` | Sinal fraco ou incompleto que vale a pena monitorar. |
| `REVIEW` | Evidências correlacionadas precisam de julgamento do administrador. |
| `BAN-ELIGIBLE` | Identidade limpa e limites de evidência configurados são conheci; as portas de gravação ainda se aplicam. |
| `AUTO-BANNED` | A aplicação foi explicitamente habilitada e o backup, a gravação, a leitura e a auditoria foram bem-sucedidos. |

Nenhum rótulo de decisão prova culpa ou intenção.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Aplicar o limite de evidência

Falhas, reconexões, avisos, object/class tokens e agrupamento de casos podem apoiar a revisão. Sozinhos, eles não provam trapaça, roubo, duplicação, propriedade, dano direto ou causa do incidente.

Se a identidade, análise, backup, gravação, leitura ou reversão forem fracas ou falharem, a aplicação deverá falhar no fechamento.

<a id="review-note-template"></a>
## Modelo de nota de revisão

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Documentos relacionados

- [`EVIDENCE_BOUNDARY.md`](LIMITE_DE_EVID%C3%8ANCIAS.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md)
- [`ADMIN_INI_ENFORCEMENT.md`](APLICA%C3%87%C3%83O_DE_INICIALIZA%C3%87%C3%83O_ADMINISTRATIVA.md)
- [`DETECTION_SIGNALS.md`](SINAIS_DE_DETEC%C3%87%C3%83O.md)
