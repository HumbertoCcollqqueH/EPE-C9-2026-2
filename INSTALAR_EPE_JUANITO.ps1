#requires -Version 5.1
<#
.SYNOPSIS
    Organiza el repositorio EPE-C9-2026-2 e instala el portal S1 de Juanito.
.DESCRIPTION
    - Verifica que el repositorio y el paquete existan.
    - Crea un respaldo fuera del repositorio antes de modificar archivos.
    - Mueve la arquitectura AWS antigua del directorio raiz a historico/CE03_AWS_V1.
    - Copia el nuevo portal, PDF, prototipo y recursos a su ubicacion definitiva.
    - Comprueba que los enlaces internos del portal no apunten a archivos inexistentes.
    - SOLO si se indica -Publicar, crea un commit y envia al remoto GitHub.
.EXAMPLE
    .\INSTALAR_EPE_JUANITO.ps1 -Simular
.EXAMPLE
    .\INSTALAR_EPE_JUANITO.ps1 -Publicar
#>
[CmdletBinding()]
param(
    [string]$Repositorio = 'C:\Users\Public\Upeu\Cursos\EPE\EPE-C9-2026-2',
    [switch]$Simular,
    [switch]$Publicar
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Log([string]$Message) { Write-Host "[EPE] $Message" -ForegroundColor Cyan }
function Aviso([string]$Message) { Write-Warning $Message }

$Repo = [System.IO.Path]::GetFullPath($Repositorio)
$Origen = Join-Path $PSScriptRoot 'plantilla'
$ArchivosOrigen = @(
    'index.html', 'README.md', '.nojekyll', '.gitignore', 'evidencias/README.md',
    'assets/css/estilos.css', 'assets/js/sitio.js',
    'assets/img/arquitectura_red_hibrida.png',
    'assets/img/centro_datos_hibrido.png',
    'assets/img/flujo_cotizaciones.png',
    'prototipos/Juanito_Tienda_Interactiva_V3.html',
    'documentos/CE01_Gobierno_TI/S1/E1_Diagnostico/CE01_S1_E1_Diagnostico_Alineamiento.pdf',
    'documentos/CE01_Gobierno_TI/S1/E2_Business_Case/CE01_S1_E2_Business_Case.pdf',
    'documentos/CE01_Gobierno_TI/S1/E3_Plan_Proyecto/CE01_S1_E3_Plan_Gestion.pdf',
    'documentos/CE01_Gobierno_TI/S1/E4_Procesos/CE01_S1_E4_ASIS_TOBE.pdf',
    'documentos/CE01_Gobierno_TI/S1/CE01_S1_Expediente_Consolidado.pdf',
    'documentos/CE03_Infraestructura/S1/E1_Red/CE0311_S1_E1_Diseno_Red_Hibrida.pdf',
    'documentos/CE03_Infraestructura/S1/E2_Centro_Datos/CE0331_S1_E2_Centro_Datos_Hibrido.pdf',
    'documentos/CE03_Infraestructura/S1/CE03_S1_Expediente_Consolidado.pdf',
    'documentos/CE02_Ingenieria_Software/S1/E1_Requisitos_Diseno/CE021_S1_E1_BORRADOR_Requisitos_Diseno.pdf',
    'documentos/Transversales/Matriz_Rubricas_CE01_CE03.pdf',
    'documentos/CE03_Infraestructura/S2/E1_SGSI/.gitkeep',
    'documentos/CE01_Gobierno_TI/S2/E5_Solucion_TIC/.gitkeep',
    'documentos/CE02_Ingenieria_Software/S2/.gitkeep',
    'evidencias/CE03_Infraestructura/S1/E1_Red/capturas/.gitkeep',
    'evidencias/CE03_Infraestructura/S1/E2_Centro_Datos/pruebas/.gitkeep',
    'evidencias/CE01_Gobierno_TI/S1/E1_Diagnostico/validacion/.gitkeep',
    'evidencias/CE01_Gobierno_TI/S1/E2_Business_Case/cotizaciones/.gitkeep',
    'evidencias/CE01_Gobierno_TI/S1/E3_Plan_Proyecto/control/.gitkeep',
    'evidencias/CE01_Gobierno_TI/S1/E4_Procesos/actas/.gitkeep',
    'evidencias/CE02_Ingenieria_Software/S1/E1_Requisitos_Diseno/validacion/.gitkeep'
)
$Antiguos = @(
    'Arquitectura_General_AWS_Juanito.png',
    'CE0311_Red_Juanito_AWS.docx',
    'CE0311_Red_Juanito_AWS.pdf',
    'CE0331_Centro_Datos_Juanito_AWS.docx',
    'CE0331_Centro_Datos_Juanito_AWS.pdf'
)

if (-not (Test-Path -LiteralPath $Repo -PathType Container)) {
    throw "No encuentro el repositorio local: $Repo"
}
if (-not (Test-Path -LiteralPath $Origen -PathType Container)) {
    throw "Falta la carpeta 'plantilla'. Extrae el ZIP COMPLETO antes de ejecutar el script."
}
foreach ($rel in $ArchivosOrigen) {
    $src = Join-Path $Origen ($rel -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $src -PathType Leaf)) {
        throw "Archivo faltante en el kit: $rel"
    }
}
if ($Publicar -and $Simular) { throw 'No combines -Publicar y -Simular.' }
$Dentro = ([System.IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\') + '\').StartsWith(($Repo.TrimEnd('\') + '\'), [StringComparison]::OrdinalIgnoreCase)
if ($Dentro) { throw 'Extrae este kit fuera del repositorio y vuelve a ejecutar desde su propia carpeta.' }

$EsGit = (Test-Path -LiteralPath (Join-Path $Repo '.git'))
if ($Publicar -and -not $EsGit) { throw 'La ruta no parece ser un clon Git (.git no existe). Clona primero el repositorio.' }
if ($Publicar -and -not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'git no esta instalado o no aparece en PATH.' }
if ($Publicar) {
    Push-Location $Repo
    try {
        $branch = (& git branch --show-current 2>$null).Trim()
        if ($branch -ne 'main') { throw "Estas en la rama '$branch'. Cambia a main antes de publicar." }
        $remote = (& git remote get-url origin 2>$null).Trim()
        if ($remote -notmatch '(?i)github\.com[:/]HumbertoCcollqqueH/EPE-C9-2026-2(?:\.git)?$') {
            throw "El remoto origin no es el repositorio esperado: $remote"
        }
        & git diff --cached --quiet
        if ($LASTEXITCODE -ne 0) { throw 'Ya tienes cambios staged en Git. Haz commit o restablecelos antes de usar -Publicar.' }
    } finally { Pop-Location }
}

Log "Repositorio: $Repo"
Log ('Archivos del kit: ' + $ArchivosOrigen.Count)
Log ('Documentos antiguos que se archivaran: ' + ($Antiguos -join ', '))
if ($Simular) {
    Write-Host ''
    Log 'SIMULACION: no se modifico ningun archivo. La instalacion real hara respaldo, creara carpetas y copiara los archivos.'
    foreach ($rel in $ArchivosOrigen) { Write-Host "  + $rel" }
    exit 0
}

$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$Parent = Split-Path -Parent $Repo
$Back = Join-Path $Parent "EPE-RESPALDO-$Stamp"
New-Item -ItemType Directory -Path $Back -Force | Out-Null
Log "Respaldo externo: $Back"

# 1) Copiar a respaldo todo archivo afectado que ya exista.
$Affected = @('index.html','README.md') + $Antiguos + $ArchivosOrigen
foreach ($rel in ($Affected | Select-Object -Unique)) {
    $native = $rel -replace '/', [IO.Path]::DirectorySeparatorChar
    $actual = Join-Path $Repo $native
    if (Test-Path -LiteralPath $actual -PathType Leaf) {
        $copy = Join-Path $Back $native
        $folder = Split-Path -Parent $copy
        if (-not (Test-Path -LiteralPath $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
        Copy-Item -LiteralPath $actual -Destination $copy -Force
    }
}

# 2) Mover a historico solo los cinco documentos de la version antigua.
$Historic = Join-Path $Repo 'historico\CE03_AWS_100_PORCIENTO_V1'
New-Item -ItemType Directory -Path $Historic -Force | Out-Null
foreach ($rel in $Antiguos) {
    $actual = Join-Path $Repo $rel
    if (Test-Path -LiteralPath $actual -PathType Leaf) {
        $dest = Join-Path $Historic $rel
        if (Test-Path -LiteralPath $dest) {
            $dest = Join-Path $Historic ("$Stamp-" + $rel)
        }
        Move-Item -LiteralPath $actual -Destination $dest
        Log "Archivado: $rel"
    }
}

# Guardar index original en respaldo externo: no publicar de nuevo una web antigua duplicada.
# 3) Copiar todos los archivos nuevos, conservando sus subcarpetas.
foreach ($rel in $ArchivosOrigen) {
    $native = $rel -replace '/', [IO.Path]::DirectorySeparatorChar
    $src = Join-Path $Origen $native
    $dst = Join-Path $Repo $native
    $folder = Split-Path -Parent $dst
    if (-not (Test-Path -LiteralPath $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
    Copy-Item -LiteralPath $src -Destination $dst -Force
}
Log 'Portal, PDFs y prototipo copiados.'

# 4) Validar rutas relativas declaradas en href/src de index.html.
$HTML = Get-Content -LiteralPath (Join-Path $Repo 'index.html') -Raw -Encoding UTF8
$regex = [regex]'(?:href|src)="([^"]+)"'
$missing = @()
foreach ($m in $regex.Matches($HTML)) {
    $url = [string]$m.Groups[1].Value
    if ($url -match '^(?:#|https?://|mailto:|data:)') { continue }
    $pathPart = [Uri]::UnescapeDataString(($url -split '[?#]')[0])
    if (-not $pathPart) { continue }
    $candidate = Join-Path $Repo ($pathPart -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) { $missing += $url }
}
if ($missing.Count -gt 0) {
    Aviso ('Hay enlaces locales sin archivo: ' + ($missing -join ', '))
    throw 'Instalacion copiada, pero la verificacion de enlaces fallo. No se publicara.'
}
Log 'Verificacion de enlaces locales: OK.'

if ($Publicar) {
    Push-Location $Repo
    try {
        & git add -A -- index.html README.md .nojekyll .gitignore assets documentos prototipos evidencias historico
        foreach ($f in $Antiguos) { & git add -A -- $f 2>$null }
        & git diff --cached --quiet
        if ($LASTEXITCODE -eq 0) {
            Log 'No hay cambios nuevos para crear commit.'
        } else {
            & git commit -m 'Organizar EPE S1: CE01 CE02 CE03 y portal Juanito'
            if ($LASTEXITCODE -ne 0) { throw 'git commit fallo: revisa la configuracion de usuario de Git.' }
        }
        & git push origin main
        if ($LASTEXITCODE -ne 0) { throw 'git push fallo: revisa autenticacion, conexion o permisos.' }
        Log 'Publicacion enviada a GitHub. GitHub Pages puede necesitar actualizacion por parte de la plataforma.'
    } finally { Pop-Location }
} else {
    Log 'No se ha hecho git push (uso seguro por defecto). Para publicar, vuelve a ejecutar con -Publicar.'
}
Write-Host ''
Write-Host 'INSTALACION COMPLETADA' -ForegroundColor Green
Write-Host "Web local:     $(Join-Path $Repo 'index.html')"
Write-Host "Documentos:    $(Join-Path $Repo 'documentos')"
Write-Host "Respaldo:      $Back"
Write-Host 'Web esperada:  https://humbertoccollqqueh.github.io/EPE-C9-2026-2/'
Write-Host 'Nota: GitHub Pages debe estar configurado en Settings > Pages > main / (root).'
