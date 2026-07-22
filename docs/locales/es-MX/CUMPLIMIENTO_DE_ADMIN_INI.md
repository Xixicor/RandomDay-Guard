<a id="adminini-enforcement"></a>
# Admin.ini cumplimiento

> **Fuente canónica en inglés:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


RandomDayGuard no cambia la lista de prohibiciones del servidor en su configuración predeterminada. Solo crea informes para que los revise un administrador. Esta página explica la actualización automática opcional de la lista de prohibiciones para los administradores que la habilitan deliberadamente.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Qué comprueba Guard antes de cambiar la lista de baneos

Guard agrega una prohibición solo cuando cada respuesta a continuación es **sí**:

1. ¿La evidencia actual identificó una cuenta específica con suficiente confianza?
2. ¿La cuenta no es moderador ni moderador? ¿Cuenta que el administrador marcó como confiable?
3. ¿La cuenta aún no está en la lista de prohibiciones?
4. ¿La cuenta alcanzó la puntuación de acción automática configurada?
5. ¿Puede Guard leer el `Admin.ini` y guardar una copia de seguridad idéntica?
6. ¿`Admin.ini` permaneció sin cambios mientras Guard preparaba la actualización?
7. Después de guardar, ¿el archivo completo coincide exactamente con el resultado deseado?

Si alguna respuesta es **no**, o no se puede verificar, Guard abandona el `Admin.ini` no cambia y registra el motivo en sus informes. Si se comienza a guardar pero la verificación final falla, Guard restaura la copia de seguridad verificada.

<a id="file-format"></a>
## Formato de archivo

`Admin.ini` debe recibir solo líneas de prohibición limpias:

```ini
BannedPlayer=<ID>
```

- Sin nombres.
- Sin comentarios.
- Sin motivos.
- No sufijos.

<a id="safe-defaults"></a>
## Valores predeterminados seguros

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Fuente de ID de prohibición

Mejor fuente:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

El tiempo de ejecución acepta una ID completamente numérica o el formulario de conexión documentado completo `<digits>_+_|<non-space token>` y deriva el ID de prohibición numérico de él. Se rechazan los prefijos numéricos arbitrarios con un sufijo desconocido; no se truncan en un ID de prohibición.

Correcto:

```ini
BannedPlayer=2535422284688820
```

Incorrecto:

```ini
BannedPlayer=ExamplePlayer
```

También incorrecto:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Configuración exacta Comprobaciones de guardia

Estas configuraciones implementan las comprobaciones descritas anteriormente. Cada condición enumerada debe ser verdadera:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Si alguna condición es falsa o no se puede verificar, Guard deja la lista de prohibiciones sin cambios y registra qué la detuvo.

<a id="transaction-safety"></a>
## Seguridad de las transacciones

La única `Admin.ini` ruta de mutación realiza estos pasos en orden:

1. Leer y validar estructuralmente los bytes autorizados.
2. Derivar el estado de moderador, de confianza y de prohibición existente de esa misma instantánea.
3. Escribir una copia de seguridad única en `runtime/backups/` y verifíquelo byte por byte.
4. Vuelva a leer `Admin.ini` inmediatamente antes del reemplazo y rechace cualquier cambio externo.
5. Escriba el candidato a través de la ruta de reemplazo controlada configurada.
6. Requiera que los bytes de lectura completos sean iguales a los bytes completos del candidato.
7. En caso de error de lectura, restaure la copia de seguridad verificada solo mientras el archivo actual siga siendo el candidato exacto escrito por Guard. Si otro escritor lo cambió, Guard rechaza la reversión en lugar de sobrescribir bytes externos desconocidos.

Los ID duplicados son idempotentes: no se escriben una segunda línea ni una segunda copia de seguridad. Los nombres de las copias de seguridad incluyen una marca de tiempo, una huella digital del byte de origen y una identificación limpia, por lo que los intentos separados no pueden compartir el antiguo nombre de archivo de un segundo.

<a id="local-regression-proof"></a>
## Prueba de regresión local

`tests/lua/enforcement_runtime_test.lua` arranca el cargador enviado una vez y luego ejecuta su cierre local real `append_ban()` contra archivos sintéticos aislados debajo del directorio del repositorio `.tmp/`. Cubre la inserción, la idempotencia duplicada, el rechazo moderator/trusted, el rechazo de identidades débiles y con formato incorrecto, la verificación de copias de seguridad exactas en bytes, el rechazo de modificaciones simultáneas, la reversión exitosa después de una lectura fallida y la negativa a sobrescribir un cambio externo posterior a la escritura. Los envoltorios de su sistema de archivos rechazan cualquier mutación fuera de la raíz del dispositivo; no se utiliza ninguna ruta de servidor real o `Admin.ini` real.

Ejecútelo a través de `python tools/test_public_pipeline.py`. Un pase fijo demuestra únicamente el comportamiento de la transacción local. No permite la aplicación de medidas, no autoriza una escritura de producción ni demuestra permisos específicos del host.

<a id="files-to-check"></a>
## Archivos para verificar

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Revertir

1. Detenga el servidor.
2. Restaurar la última Admin.ini copia de seguridad de `runtime/backups/`.
3. Elimine la línea `BannedPlayer=<ID>` incorrecta si es necesario.
4. Inicie el servidor.
5. Vuelva a abrir Admin.ini y confirme que la línea persiste o se eliminó.
6. Conserve `enforced_bans.jsonl` para auditoría.

<a id="related-docs"></a>
## Documentos relacionados

* [`BAN_ID_MAPPING.md`](ASIGNACI%C3%93N_DE_ID_DE_PROHIBICI%C3%93N.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
