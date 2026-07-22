<a id="validation-and-release"></a>
# Validación y publicación

> **Fuente canónica en inglés:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Esta página es para contribuyentes y mantenedores de versiones. Los operadores de servidores no necesitan ejecutar estos comandos para instalar RandomDayGuard.

<a id="user-visible-proof"></a>
## Prueba visible para el usuario

Una versión es comprensible cuando un nuevo operador puede instalarla, encontrar el primer informe de estado del servidor, distinguir las cinco rutas de informes y seguir una acción clara de un ejemplo trabajado. Las tareas de lectura no deben requerir conocimientos de Git, PowerShell, Python o suma de comprobación.

<a id="contributor-checks"></a>
## Verificaciones del colaborador

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Cuando `luac` es. disponible:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Las pruebas de dispositivos Lua cubren el cargador, el programador, las rutas de informes y las Admin.ini transacciones de escritura opcionales que utilizan archivos temporales únicamente y verifican la identidad, el rechazo de cuentas confiables, los umbrales, la copia de seguridad, el rechazo de cambios simultáneos, la lectura y la reversión.

<a id="package-proof"></a>
## Prueba del paquete

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Todos los marcadores de versión coinciden `VERSION`.
- Solo existe la versión actual en `releases/`.
- El ZIP contiene los bytes canónicos `RandomDayGuard/Scripts/main.lua` y ningún cargador de variantes en minúsculas.
- Se excluyen la salida del tiempo de ejecución, la configuración privada, las credenciales, las rutas locales, las cachés y los artefactos de prueba.
- La configuración pública sigue siendo de solo revisión con la aplicación deshabilitada.
- Los cinco ejemplos de informes trabajados siguen siendo consistentes con la propiedad de la ruta y el dispositivo de prueba de lanzamiento.
- ZIP que son deterministas y coincidentes `CHECKSUMS.sha256`.
- Todos los enlaces de documentación local y 27 páginas de entrada de configuración regional se validan.

<a id="avoid-validation-environment-pitfalls"></a>
## Evita los problemas del entorno de validación

- Ejecuta comprobaciones de escritura del repositorio en serie para evitar la contención de archivos temporales.
- En Windows, inspecciona los nombres de los miembros archivados o la ortografía de las rutas enumeradas en lugar de realizar una búsqueda de archivos que no distinga entre mayúsculas y minúsculas cuando busques duplicados. cargadores.
- Un comando `luac` faltante o tiempo de ejecución de Lua es una capacidad no disponible, no una prueba de sintaxis o tiempo de ejecución que pasa.
- Un dispositivo prueba solo sus entradas modeladas. No prueba que un servidor en vivo haya producido un informe actual.
- Registre los tiempos de espera de los comandos y la salida parcial en lugar de asumir que se completó.

<a id="repair-failed-repository-validation"></a>
## Reparar la validación fallida del repositorio

Comience con la primera ruta o contrato reportado. Corrija ese elemento, vuelva a ejecutar la prueba estrecha y luego vuelva a ejecutar la matriz completa. No oculte una capacidad faltante eliminando la prueba que la requiere.

<a id="known-limits-and-release-decision"></a>
## Límites conocidos y decisión de liberación

Las verificaciones locales prueban los contratos de fuente, instalación, paquete y documentación. Una instalación de servidor específica, una ventana de estabilidad de larga duración o una pantalla de cliente requieren un resultado de integración separado. Registre ese resultado con su compilación, configuración, duración y resultados observados antes de realizar la afirmación coincidente.
