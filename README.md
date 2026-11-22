# Perfil de Egreso S1 — Creaciones y Artesanías Juanito

Repositorio académico organizado para las competencias de especialidad **CE03 (Infraestructura Tecnológica), CE01 (Gestión de TI) y CE02 (Ingeniería de Software)**.

## Ver el sitio

- Web pública: https://humbertoccollqqueh.github.io/EPE-C9-2026-2/
- Prototipo de demostración: `prototipos/Juanito_Tienda_Interactiva_V3.html`
- Documento oficial de evaluación: https://upeuoficial.github.io/planb/transcripcion/

## Documentos S1

| Competencia | Evidencia | Ruta |
|---|---|---|
| CE03 | CE0311 - Red híbrida | `documentos/CE03_Infraestructura/S1/E1_Red/` |
| CE03 | CE0331 - Centro de datos híbrido | `documentos/CE03_Infraestructura/S1/E2_Centro_Datos/` |
| CE01 | CE0111-CE0115 - Diagnóstico | `documentos/CE01_Gobierno_TI/S1/E1_Diagnostico/` |
| CE01 | CE0113 - Business Case | `documentos/CE01_Gobierno_TI/S1/E2_Business_Case/` |
| CE01 | CE0121-CE0125 - Plan de gestión | `documentos/CE01_Gobierno_TI/S1/E3_Plan_Proyecto/` |
| CE01 | CE0131-CE0135 - AS-IS/TO-BE | `documentos/CE01_Gobierno_TI/S1/E4_Procesos/` |
| CE02 | CE021 - Requerimientos y diseño | `documentos/CE02_Ingenieria_Software/S1/E1_Requisitos_Diseno/` |

**CE0321–CE0324 (SGSI) corresponde a S2**, aparece en la web como planificación futura y no como S1 entregado.

## Proyecto común

La propuesta contempla el negocio y las sucursales de **Muñani, Juliaca y Puno**, nueve dominios funcionales, plataforma compartida con referencia de infraestructura **VPC 10.42.0.0/16**, y una red **híbrida AWS + entorno ESXi local en Juliaca** como diseño académico.

El prototipo web V3 funciona de manera local en el navegador. **No es producción**: carece de autenticación segura, backend comercial y base de datos centralizada. No utilices contraseñas reales en él.

Los PDF de CE01 y CE03 son expedientes de planificación/diseño. El PDF CE02 está rotulado como **borrador**, pendiente de validación con interesados. Las cifras financieras y de desempeño del expediente deben corroborarse con información real antes de sustentar.

## Estructura

```text
EPE-C9-2026-2/
├── index.html                         # Web pública GitHub Pages
├── assets/
│   ├── css/estilos.css
│   ├── js/sitio.js
│   └── img/                            # Arquitecturas ilustrativas
├── documentos/
│   ├── CE03_Infraestructura/S1/
│   │   ├── E1_Red/
│   │   └── E2_Centro_Datos/
│   ├── CE01_Gobierno_TI/S1/
│   │   ├── E1_Diagnostico/
│   │   ├── E2_Business_Case/
│   │   ├── E3_Plan_Proyecto/
│   │   └── E4_Procesos/
│   ├── CE02_Ingenieria_Software/S1/E1_Requisitos_Diseno/
│   └── Transversales/
├── prototipos/Juanito_Tienda_Interactiva_V3.html
└── historico/CE03_AWS_100_PORCIENTO_V1/  # Docs de diseño previo
```

## Publicación

El kit de instalación `INSTALAR_EPE_JUANITO.ps1`, entregado por separado, crea respaldo fuera del repositorio y organiza automáticamente los archivos. Para publicar con Git, el equipo debe tener permisos de escritura y `git` configurado.

Tras publicar verifica en GitHub **Settings → Pages → Deploy from a branch → main → /(root)**.

## Estado de evidencias

- Documentos PDF de CE01-S1 y CE03-S1: disponibles para revisión.
- CE02-S1: borrador con trazabilidad, vistas C4 y UML, pendiente validación de usuarios y sustentación.
- CE03-S2/SGSI: referencia de trabajo futuro; no es entrega S1.
- AWS/ESXi, identidades reales, respaldos y métricas: diseño, no implantación comprobada.

**Nota académica:** la página oficial consultada está titulada «Eval. perfil egreso ≤ 2023». Confirma la malla aplicable con el docente.
