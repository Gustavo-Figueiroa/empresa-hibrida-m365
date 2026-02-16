
# PROVISIONAMENTO COMPLETO

param(
    [string]$Nome,
    [string]$Sobrenome,
    [string]$Usuario,
    [string]$Senha,
    [string]$Dominio = "techsolutions.local",
    [string]$UPNDomain = "techsolutions.onmicrosoft.com"
)

# 1️⃣ Criar usuário no Active Directory
New-ADUser `
    -Name "$Nome $Sobrenome" `
    -GivenName $Nome `
    -Surname $Sobrenome `
    -SamAccountName $Usuario `
    -UserPrincipalName "$Usuario@$UPNDomain" `
    -AccountPassword (ConvertTo-SecureString $Senha -AsPlainText -Force) `
    -Enabled $true `
    -ChangePasswordAtLogon $true

Write-Host "Usuário criado no AD."

# 2️⃣ Forçar sincronização com Azure AD
Start-ADSyncSyncCycle -PolicyType Delta
Write-Host "Sincronização iniciada."

# 3️⃣ Conectar no Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All"

# 4️⃣ Aplicar licença (Business Premium exemplo)
$sku = Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -eq "BUSINESS_PREMIUM"}

Set-MgUserLicense -UserId "$Usuario@$UPNDomain" `
    -AddLicenses @{SkuId = $sku.SkuId} `
    -RemoveLicenses @()

Write-Host "Licença aplicada."

# 5️⃣ Adicionar a grupo de segurança
$group = Get-MgGroup -Filter "displayName eq 'Usuarios-Padrao'"
Add-MgGroupMember -GroupId $group.Id -DirectoryObjectId (Get-MgUser -UserId "$Usuario@$UPNDomain").Id

Write-Host "Usuário adicionado ao grupo."

Write-Host "Provisionamento concluído com sucesso!"
