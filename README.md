<h1 align="center">
  <br>
  <a href="https://github.com/matiasdante"><img src="https://upload.wikimedia.org/wikipedia/commons/2/2f/PowerShell_5.0_icon.png" alt="Proyectos DevOps" width="200"></a>
  <br>
  Verificador de Actualizaciones de Windows
  <br>
</h1>
<h4 align="center">Script de PowerShell para verificar actualizaciones pendientes de Windows con información detallada</h4>
<p align="center">
  <a href="#Funciones">Funciones</a> •
  <a href="#Prerequisitos">Prerequisitos</a> •
  <a href="#Descarga">Descarga</a> •
  <a href="#Como-usarlo">Cómo usarlo</a> •
  <a href="#Salida">Salida</a> •
  <a href="#Créditos">Créditos</a> 
</p>

## Funciones
Con este script podrás...
- **Consultar el Servicio de Windows Update**: Se conecta a Microsoft Update Session para obtener actualizaciones pendientes
- **Información Detallada de Actualizaciones**: Muestra títulos de actualizaciones, IDs de artículos KB y tamaños de descarga
- **Inventario Automatizado**: Evalúa rápidamente qué actualizaciones están pendientes de instalación en tu sistema
- **Administración de Sistemas**: Perfecto para gestión de parches y reportes de cumplimiento

## Prerequisitos
Antes de ejecutar este script, asegúrate de tener:
- **Windows PowerShell 5.1 o superior** (o PowerShell Core 6+)
- **Privilegios administrativos** (recomendado para acceso completo a Windows Update)
- **Servicio de Windows Update** habilitado y en ejecución
- **Conectividad a Internet** para obtención de metadatos de actualizaciones

## Descarga
Primero, necesitarás tener git instalado en tu máquina. Si no lo tienes, consulta el siguiente enlace: [Git](https://git-scm.com)

Clona este repositorio:
```powershell
git clone https://github.com/matiasdante/windows-update-checker.git
```

## Cómo usarlo

1. **Navega al directorio del script**:
```powershell
cd windows-update-checker
```

2. **Establece la política de ejecución** (si es necesario):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

3. **Ejecuta el script**:
```powershell
.\updates.ps1
```

### Alternativa: Ejecución directa
También puedes ejecutar el script directamente copiando y pegando el código en una sesión de PowerShell:

```powershell
$Searcher = New-Object -ComObject Microsoft.Update.Session
$Results = $Searcher.CreateUpdateSearcher().Search("IsInstalled=0").Updates
$Results | ForEach-Object { 
    [PSCustomObject]@{ 
        Title = $_.Title 
        KBs = ($_.KBArticleIDs -join ", ") 
        Size = $_.MaxDownloadSize 
    } 
}
```

## Salida
El script devuelve un objeto estructurado para cada actualización pendiente que contiene:

| Propiedad | Descripción | Ejemplo |
|-----------|-------------|---------|
| **Title** | Nombre completo de la actualización | "Actualización Acumulativa 2024-01 para Windows 11" |
| **KBs** | IDs de artículos de Knowledge Base | "KB5034203, KB5034204" |
| **Size** | Tamaño máximo de descarga en bytes | "512000000" (≈ 512 MB) |

### Ejemplo de Salida:
```
Title                                         KBs        Size
-----                                         ---        ----
Actualización Acumulativa 2024-01 para Win   KB5034203  512000000
Actualización de Microsoft Defender          KB2267602  45000000
Actualización de Seguridad .NET Framework    KB5034122  128000000
```

## Uso Avanzado

### Exportar a CSV
```powershell
$Updates = .\Check-WindowsUpdates.ps1
$Updates | Export-Csv -Path "actualizaciones-pendientes.csv" -NoTypeInformation
```

### Filtrar por tamaño
```powershell
$Updates = .\Check-WindowsUpdates.ps1
$Updates | Where-Object { $_.Size -gt 100000000 } | Format-Table
```

### Obtener tamaño total de descarga
```powershell
$Updates = .\Check-WindowsUpdates.ps1
$TotalSize = ($Updates | Measure-Object -Property Size -Sum).Sum
Write-Host "Tamaño total de descarga: $([math]::Round($TotalSize/1MB, 2)) MB"
```

## Solución de Problemas

**Error: "Acceso denegado"**
- Ejecuta PowerShell como Administrador
- Asegúrate de que el servicio de Windows Update esté en ejecución

**Error: "El servidor RPC no está disponible"**
- Verifica el estado del servicio de Windows Update
- Confirma la conectividad de red

**No se devuelven resultados**
- Todas las actualizaciones pueden ya estar instaladas
- Verifica la configuración de Windows Update en el Panel de Control

## Créditos
* Desarrollado para flujos de trabajo de administración de sistemas y gestión de parches
* Basado en la interfaz COM de Microsoft Update Session
* [matiasdante](https://github.com/matiasdante) - DevOps Jr
