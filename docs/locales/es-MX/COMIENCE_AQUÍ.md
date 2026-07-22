<a id="start-here-read-the-first-guard-report"></a>
# Comience aquí: lea el primero Informe de guardia

> **Fuente canónica en inglés:** [START_HERE.md](../../START_HERE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Esta guía comienza después de que RandomDayGuard esté instalado y habilitado. Demuestra un resultado útil sin pedirle a un nuevo operador que inspeccione el código fuente, los componentes internos del paquete o los archivos de estado exclusivos de la máquina.

<a id="what-happens-after-the-server-starts"></a>
## Qué sucede después de que se inicia el servidor

Guard espera a que el servidor del juego y UE4SS se carguen, encuentra los registros disponibles del servidor e inicia un análisis en segundo plano limitado. Puede informar el estado actual del servidor mientras aún se está indexando el historial anterior.

El primer informe debe ser **Estado del servidor**. Responde si Guard está completando los ciclos de monitoreo ahora, cuándo comenzó la ejecución actual del servidor, si esa marca de tiempo está disponible, cuánto active/rotated cobertura de registro y escaneo existe, cuántos reproductores están conectados, qué grupos de fuentes faltan y si se necesita una acción del operador.

Un escaneo en segundo plano que aún está progresando es una limitación en la cobertura histórica, no automáticamente una falla de inicio. Guard registra el cursor de escaneo, los archivos completados, los archivos descubiertos y el último tiempo de progreso. Si esos valores dejan de cambiar a través de ciclos de monitoreo repetidos, trate la ruta histórica como estancada y siga la rama de escaneo en Solución de problemas. No descarte los resultados del registro y la sesión actuales únicamente porque el historial anterior esté incompleto.

<a id="read-the-first-server-status-report"></a>
## Lea el primer informe de estado del servidor

1. Inicie el servidor dedicado normalmente.
2. Espera a que el servidor del juego y UE4SS terminen de iniciar.
3. Abrir RandomDayGuard's carpeta de informes finales y elija el informe de estado del servidor legible más reciente.
4. Confirme que el informe contiene:
   - **Resumen**
   - **Lo que observó Guard**
   - **Qué significa**
   - **Lo que permanece desconocido**
   - **Siguiente paso recomendado**
   - **Registro técnico**
5. En **Lo que observó Guard**, confirma los últimos avances del ciclo de monitoreo y los nombres de los informes disponibles: registro, escaneo, reproductor y cobertura de origen.
6. Si el siguiente paso dice que no se necesita intervención, mantenga el informe como el primer resultado exitoso. Si menciona una fuente faltante o un proceso detenido, siga ese síntoma exacto en [Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md).

El informe puede vincularse a evidencia técnica para una revisión más profunda. Un operador normal puede leer el informe primero y abrir esas referencias solo cuando sea necesario verificar el resultado simple.

<a id="understand-quiet-reports"></a>
## Comprender los informes silenciosos

La actividad del jugador, la revisión de casos y la Guardia crítica se basan en eventos. Un servidor silencioso no debería producir un jugador, un caso o un fallo ficticio simplemente para llenar un canal. El resultado legible puede indicar que se verificó la fuente y que no pertenecía nada a ese informe.

El resumen diario es diferente: proporciona una revisión por fecha del informe utilizando las sesiones del mismo día, los temas de revisión actuales, el identity/case contexto retenido, el progreso del análisis y las lagunas en las fuentes que Guard realmente puede leer. Los hechos que no aparecen en los registros del servidor disponibles permanecen desconocidos en lugar de ser estimados.

<a id="test-one-ordinary-player-session"></a>
## Prueba una sesión de jugador normal

Después de que el primer informe de estado del servidor esté actualizado:

1. Deja que un jugador conocido se una y se retire normalmente.
2. Espera el siguiente ciclo de informes.
3. Abre el reproductor actividad.
4. Confirme que identifique la cuenta o el nombre para mostrar disponible para Guard, las horas de entrada y salida, el resultado de la sesión limpia o incompleta, el historial anterior cuando esté disponible y una acción siguiente.

El informe de la sesión debe contener los datos observados. No debe reemplazarse por una lista de nombres de archivos o una declaración genérica de que existen registros.

<a id="continue"></a>
## Continuar

- [Cinco ejemplos de informes](EJEMPLOS_DE_INFORMES.md)
- [Manual de operaciones](MANUAL_DE_OPERACIONES.md)
- [Flujo de trabajo de revisión del jugador](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
- [Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md)
- [Índice de documentación completa](DOCUMENTACI%C3%93N.md)
