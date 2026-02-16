New-ADFineGrainedPasswordPolicy `
-Name "SenhaForte-12Caracteres" `
-Precedence 1 `
-MinPasswordLength 12 `
-PasswordHistoryCount 24 `
-MaxPasswordAge (New-TimeSpan -Days 90) `
-MinPasswordAge (New-TimeSpan -Days 1) `
-ComplexityEnabled $true `
-LockoutThreshold 5 `
-LockoutDuration (New-TimeSpan -Minutes 15) `
-LockoutObservationWindow (New-TimeSpan -Minutes 15)

#Agora aplicar essa política a um grupo:
Add-ADFineGrainedPasswordPolicySubject `
-Identity "SenhaForte-12Caracteres" `
-Subjects "Usuarios-Padrao"
