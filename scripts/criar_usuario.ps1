# Script para criação de usuário no Active Directory

param(
    [string]$Nome,
    [string]$Sobrenome,
    [string]$Usuario,
    [string]$Senha
)

New-ADUser `
    -Name "$Nome $Sobrenome" `
    -GivenName $Nome `
    -Surname $Sobrenome `
    -SamAccountName $Usuario `
    -AccountPassword (ConvertTo-SecureString $Senha -AsPlainText -Force) `
    -Enabled $true

Write-Host "Usuário criado com sucesso!"
