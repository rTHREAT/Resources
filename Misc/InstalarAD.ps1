<#
Autor: Miguel Juarez
Descripción: Script para instalar Active Directory (AD DS) y crear un nuevo bosque en Windows Server.
Compatibilidad: Windows Server 2016/2019
Ejecutar: PowerShell como Administrador
#>

# ===== 1. Variables de configuración =====
$NewHostname = "DC01"                # Nuevo nombre del servidor
$IPAddress = "192.168.1.10"          # IP estática
$PrefixLength = 24                   # Máscara en formato CIDR (24 = 255.255.255.0)
$Gateway = "192.168.1.1"             # Gateway
$DNSServer = "192.168.1.10"          # DNS (puede ser el mismo servidor)
$DomainName = "empresa.local"        # Nombre del dominio
$NetbiosName = "EMPRESA"             # Nombre NetBIOS
$DSRMPassword = (ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force)  # Contraseña DSRM

Write-Host "==== Configurando el servidor para Active Directory ====" -ForegroundColor Cyan

# ===== 2. Cambiar nombre del servidor =====
Write-Host "Cambiando nombre del servidor a $NewHostname..."
Rename-Computer -NewName $NewHostname -Force

# ===== 3. Configurar IP estática =====
Write-Host "Configurando IP estática $IPAddress ..."
$Adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
New-NetIPAddress -InterfaceIndex $Adapter.InterfaceIndex -IPAddress $IPAddress -PrefixLength $PrefixLength -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $Adapter.InterfaceIndex -ServerAddresses $DNSServer

# ===== 4. Instalar Active Directory Domain Services =====
Write-Host "Instalando rol AD DS..."
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# ===== 5. Promocionar a Controlador de Dominio =====
Write-Host "Promocionando servidor a Controlador de Dominio para $DomainName..."
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -SafeModeAdministratorPassword $DSRMPassword `
    -InstallDNS `
    -Force

# ===== 6. Reiniciar automático tras la promoción =====
Write-Host "El servidor se reiniciará para aplicar los cambios..." -ForegroundColor Green
Restart-Computer -Force

