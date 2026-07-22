<a id="detection-signals"></a>
# Señales de detección

> **Fuente canónica en inglés:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Las señales son entradas de revisión, no acusaciones automáticas.

<a id="signal-table"></a>
## Tabla de señales

| Señal | Significado | Más fuerte cuando... | No es suficiente por sí sola |
|---|---|---|---|
| Identidad de inicio de sesión | Asigna el nombre al ID de cuenta | ConnectID está presente | Ban |
| Salida limpia | Cierre normal de sesión | Unirse y abandonar la partida | Sospecha |
| Reconexión rápida | Churn/probing contexto | Se repite rápidamente | Ban |
| Desconexión no limpia | La sesión no se cerró correctamente | Se repite o se superponen bloqueos | Ban |
| Se superponen bloqueos | Cuenta activa cerca del bloqueo | Se repite la misma cuenta | Ban |
| Regreso posterior a una falla | La cuenta regresa después del reinicio | Se repite en distintas épocas | Prohibición por un evento |
| Ráfaga de advertencia | Ventana de advertencia del servidor | Se superpone a sesiones asignadas | Prohibición por una ráfaga |
| Toque de guardado del actor | Contexto de guardado mundial | Se correlaciona con sesiones | Prueba de use/theft |
| Delta de objeto | World/class cambio | Se correlaciona con sesiones | Prohibición de contar solo |
| Caso de incursión | Clúster de cuentas múltiples | Cuenta central se repite | Prohibición masiva de todas las cuentas |

<a id="login-identity"></a>
## Identidad de inicio de sesión

Mejor fuente:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Úselo para mapear:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Reconexión rápida

Patrón:

```text
join -> leave -> join -> leave -> join
```

Úselo para revisión cuando se repita.

Seguridad:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Superposición de fallas y retorno posterior a la falla

Patrón:

```text
account active before crash
server restarts
same account returns quickly
```

Usar para revisión cuando se repite épocas.

Seguridad:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Ráfagas de advertencia

Ejemplos:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Utilizar como contexto hasta que se vincule a sesiones y umbrales asignados.

<a id="actor-save-touch"></a>
## Toque de guardado del actor

Significado:

```text
The server evidence referenced a class or actor.
```

Sin significado:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Casos de incursión

Un caso de redada agrupa cuentas por tiempo y ventanas compartidas.

Regla:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Documentos relacionados

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](PATRONES_DE_MALOS_ACTORES_Y_RESILIENCIA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
