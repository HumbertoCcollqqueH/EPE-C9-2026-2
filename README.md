# Perfil de Egreso S1 — Creaciones y Artesanías Juanito

Tres competencias, siete carpetas completas de entregables, sin subcarpetas genéricas S1/S2.

## Estado de avance

- CE01 — E1 (diagnóstico y alineamiento): documento Word integral + Word separados 1.1/1.3/1.4 + Excel 1.2/1.3/1.4. **Pendiente de validación con responsables del negocio.**
- CE01 — E2/E3/E4, CE03 — E1/E2, CE02 — E1: **carpetas vacías preparadas**.

Las carpetas aún no desarrolladas contienen únicamente `.gitkeep` para que Git pueda conservarlas.

## Criterios de honestidad técnica

- Muñani, Juliaca y Puno son sedes declaradas por el equipo, sin especificación verificada de función por establecimiento.
- El HTML de Juanito es un prototipo; el uso de `window.localStorage` no equivale a un backend compartido.
- Laravel, Keycloak, AWS, Wazuh/Suricata y VPN híbrida pertenecen a documentos/diseños técnicos y laboratorio de referencia, no a una instalación productiva acreditada de Juanito.
- Los objetivos, problemas, estructuras y metas señalados como propuestas o hipótesis deben validarse con dirección, entrevistas, registros y actas.
- Rúbrica base: https://upeuoficial.github.io/planb/transcripcion/ (identificada para planes ≤ 2023; verificar aplicabilidad).

## Reorganización

El instalador `INSTALAR_EPE_S1_PASO1.ps1` se ejecuta **desde fuera de este repositorio**. Antes de sustituir los archivos visibles, archiva el contenido anterior fuera del repositorio conservando `.git` y `.github`.

## Publicación

Abrir `index.html` localmente para revisar. Después, `git status`, `git add -A`, `git commit -m "EPE S1: estructura limpia y CE01 E1"`, `git push origin main`.
