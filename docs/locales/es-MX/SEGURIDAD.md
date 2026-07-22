<a id="security-policy"></a>
# Política de seguridad

> **Fuente canónica en inglés:** [SECURITY.md](../../../SECURITY.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


<a id="report-a-vulnerability-privately"></a>
## Informar una vulnerabilidad de forma privada

Utilice [GitHub informe de vulnerabilidad privado](https://github.com/Xixicor/RandomDay-Guard/security/advisories/new) para enviar un informe confidencial al propietario del repositorio. Si ese formulario no está disponible, utilice el [perfil público GitHub del propietario](https://github.com/Xixicor) para solicitar un canal de contacto privado sin incluir detalles de vulnerabilidad.

No abra una edición pública que contenga pasos de explotación, credenciales, rutas de servidores privados, identificadores de jugadores, `Admin.ini`, datos guardados, URL de webhooks o archivos de evidencia en vivo.

<a id="include-useful-evidence"></a>
## Incluya evidencia útil

Proporcione:

- la versión RandomDayGuard afectada o confirme;
- el componente afectado y el comportamiento seguro esperado;
- pasos mínimos de reproducción utilizando accesorios desinfectados;
- el impacto observado y si es repetible; y
- cualquier propuesta de mitigación que no exponga datos privados.

No envíe secretos reales. Reemplace las rutas privadas, los identificadores de cuentas, los nombres de host y los tokens con marcadores de posición claros y, al mismo tiempo, preserve la estructura necesaria para reproducir el problema.

<a id="expect-review-first-handling"></a>
## Espere un manejo de revisión primero

Un informe es evidencia para la revisión del mantenedor, no autorización para acceder a un servidor, probar un objetivo en vivo, publicar detalles de exploits o debilitar los valores predeterminados cerrados por fallas. El propietario validará el alcance y coordinará cualquier divulgación a través del informe privado.
