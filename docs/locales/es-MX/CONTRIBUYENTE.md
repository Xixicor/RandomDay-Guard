<a id="contributing"></a>
# Contribuyente

> **Fuente canónica en inglés:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


RandomDayGuard acepta mejoras enfocadas y reproducibles en analizadores, documentación, pruebas y validación pública segura. Mantenga cada cambio vinculado al contrato del proyecto público y preserve el comportamiento de revisión primero: Guard debe dejar `Admin.ini` sin cambios cuando no se pueda confirmar una verificación de seguridad requerida.

<a id="prepare-a-safe-workspace"></a>
## Prepare un espacio de trabajo seguro

1. Bifurque o clone el repositorio y cree una rama enfocada.
2. Instale un intérprete de Python 3 compatible. Instale un compilador de Lua cuando cambie Lua para que `luac -p` pueda verificar la sintaxis.
3. Lea la [inicio de documentación](DOCUMENTACI%C3%93N.md), [arquitectura](ARQUITECTURA.md) y [límite de evidencia](L%C3%8DMITE_DE_EVIDENCIA.md) para el área que cambiará.
4. Inspeccione `git status` antes de editar y preserve el trabajo no relacionado.
5. Utilice únicamente accesorios sintéticos o desinfectados.

Nunca envíe registros de servidor privados, carpetas guardadas, identificadores de reproductor, `Admin.ini`, puntos finales de notificación privados, credenciales, rutas privadas, resultados de tiempo de ejecución o evidencia en vivo copiada.

<a id="make-a-focused-change"></a>
## Realice un cambio enfocado

- Siga los nombres, el formato, las comprobaciones de seguridad y la propiedad del módulo existentes.
- Mantenga un propietario de documentación canónica para cada procedimiento o hecho exacto.
- Actualice la documentación del usuario y los ejemplos cuando cambie el comportamiento o la salida pública.
- Agregue una prueba de regresión para corregir errores cuando sea práctico.
- No debilite la confirmación de la cuenta, la protección de la cuenta confiable, la verificación de la copia de seguridad, la detección de cambios externos, la comparación de archivos guardados, la recuperación o los valores predeterminados de solo revisión para realizar una prueba.

<a id="run-the-relevant-checks"></a>
## Ejecute las comprobaciones pertinentes

Para cambios solo en la documentación, ejecute:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Para cambios de fuente, configuración, empaquetado o prueba, ejecute también las comprobaciones correspondientes desde [Revisión de validación y lanzamiento](VALIDACI%C3%93N_Y_PUBLICACI%C3%93N.md), incluidas comprobaciones de sintaxis de Lua, validación de repositorios, pruebas de canalización pública y el conjunto completo de pruebas unitarias. Informar cada cheque omitido o no disponible; no lo describas como aprobado.

<a id="submit-the-change-for-review"></a>
## Envíe el cambio para revisión

Abra una solicitud de extracción enfocada solo después de revisar la diferencia completa. Incluye:

- el problema y el comportamiento previsto;
- archivos exactos y contratos públicos modificados;
- comandos ejecutados y sus resultados;
- privacidad, compatibilidad e impacto en la aplicación; y
- limitaciones restantes o trabajo de seguimiento.

No incluya evidencia de tiempo de ejecución generada ni archivos de publicación a menos que el cambio los requiera y valide explícitamente. Una contribución no autoriza un lanzamiento, implementación, prueba de servidor en vivo, acción de cumplimiento o publicación en un sitio de terceros.

Informe vulnerabilidades a través de [la ruta de seguridad privada](SEGURIDAD.md), no como un problema público o una solicitud de extracción ordinaria.
