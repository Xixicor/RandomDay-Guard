<a id="install-randomdayguard"></a>
# Instalar RandomDayGuard

> **Fuente canónica en inglés:** [INSTALL.md](../../../INSTALL.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Esta guía instala `v0.4.12-alpha` en un servidor dedicado de Abiotic Factor que ya use UE4SS. El mod no está vinculado a una empresa de hosting ni a un panel de control.

<a id="before-you-begin"></a>
## Antes de comenzar

Necesitas:

- acceso para detener e iniciar el servidor dedicado;
- la carpeta del servidor UE4SS `Mods` carpeta;
- una copia de la carpeta RandomDayGuard actual si está actualizando;
- una copia de seguridad de los datos del servidor que normalmente proteges antes de cambiar un mod.

El **Carpeta Mods** es la `ue4ss/Mods/` directorio dentro de la instalación del servidor dedicado. RandomDayGuard pertenece directamente dentro de esa carpeta.

<a id="new-installation"></a>
## Nueva instalación

1. Detenga el servidor dedicado.
2. Extraiga el RandomDayGuard ZIP en una nueva carpeta vacía.
3. Copiar lo extraído `RandomDayGuard` carpeta en la carpeta UE4SS `Mods`. El resultado debería ser uno `Mods/RandomDayGuard/` del servidor, no una segunda carpeta RandomDayGuard anidada dentro
4. Abrir UE4SS `mods.txt` y habilite:

   ```text
   RandomDayGuard : 1
   ```

5. Inicie el servidor normalmente.
6. Espera a que UE4SS y el servidor del juego. para terminar de comenzar, luego siga [Lea el primer informe](COMIENCE_AQU%C3%8D.md).

No copie una nueva versión sobre una instalación en ejecución. Mantenga la copia de seguridad hasta que la instalación actualizada haya generado un informe actual del estado del servidor.

<a id="update-an-existing-installation"></a>
## Actualizar una instalación existente

1. Detenga el servidor.
2. Copia la carpeta RandomDayGuard instalada completa a una ubicación de copia de seguridad segura.
3. Mueve la carpeta del programa anterior fuera de UE4SS `Mods` en lugar de superponer la nueva versión.
4. Copia la nueva carpeta RandomDayGuard en `Mods`.
5. Restaura solo la configuración local revisada y la evidencia guardada. Si la guía de configuración enumera nuevos campos, combínelos en la copia revisada en lugar de reemplazar todas las configuraciones a ciegas.
6. Confirme que `RandomDayGuard : 1` permanece habilitado.
7. Inicie el servidor y lea el informe de estado actual del servidor.

Esta actualización de carpeta limpia también elimina archivos obsoletos de versiones anteriores sin pedirle al operador que inspeccione el programa. nombres de archivos.

<a id="help-guard-find-the-server-records"></a>
## Ayuda a Guard a encontrar los registros del servidor

Guard normalmente encuentra el directorio del factor abiótico `Saved` automáticamente. Si no puede, coloque la ruta completa a ese directorio `Saved` en `SavedRoot.txt` dentro de RandomDayGuard. Seleccione `Saved`, no un mundo individual debajo de él.

El primer informe de estado del servidor indica si se encontró la ubicación del registro y qué grupos de origen estaban disponibles. Utilice [Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md) cuando no pueda leer la ubicación.

<a id="first-run-behavior"></a>
## Comportamiento de primera ejecución

La instalación predeterminada observa los registros disponibles y escribe informes. No cambia `Admin.ini` ni agrega una prohibición. Esto le permite confirmar la calidad de la recopilación, la traducción y el informe antes de decidir si habilitar alguna acción opcional.

[Lea el primer informe](COMIENCE_AQU%C3%8D.md)

<a id="disable-or-remove-randomdayguard"></a>
## Desactivar o eliminar RandomDayGuard

1. Detenga el servidor.
2. Copiar la carpeta RandomDayGuard completa en un archivo seguro.
3. Para deshabilitar el mod, configura `RandomDayGuard : 0` en UE4SS `mods.txt`.
4. Para eliminarla, mueva la carpeta RandomDayGuard completa fuera de `Mods` después de confirmar que el archivo se puede abrir.
5. Inicie el servidor y confirme que Guard ya no se inicia.

Deshabilitar o eliminar Guard detiene la recopilación futura. No elimina los datos del juego, no borra los informes archivados ni revierte una acción independiente del operador.

<a id="roll-back-an-update"></a>
## Revertir una actualización

Si la nueva instalación no se carga o no puede producir un informe actual:

1. Detenga el servidor.
2. Deje a un lado la instalación fallida sin eliminar sus registros.
3. Restaura la carpeta RandomDayGuard previa a la actualización completa.
4. Restaura la configuración revisada y la evidencia guardada desde la misma copia de seguridad.
5. Confirma que el mod esté habilitado e inicia el servidor.
6. Lee el informe de estado del servidor restaurado antes de realizar otro cambio.

<a id="more-help"></a>
## Más ayuda

- [Lea el primer informe](COMIENCE_AQU%C3%8D.md)
- [Manual de operaciones](MANUAL_DE_OPERACIONES.md)
- [Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md)
- [Perfiles de configuración](PERFILES_DE_CONFIGURACI%C3%93N.md)
- [Admin.ini cumplimiento](CUMPLIMIENTO_DE_ADMIN_INI.md)

Los encargados de la versión pueden encontrar comprobaciones de fuente, paquete y privacidad en [Validación y publicación](VALIDACI%C3%93N_Y_PUBLICACI%C3%93N.md). No son necesarios para una instalación normal.
