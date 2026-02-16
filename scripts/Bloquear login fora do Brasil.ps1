#1️⃣ Criar localização Brasil
$location = @{
    displayName = "Brasil"
    countriesAndRegions = @("BR")
    includeUnknownCountriesAndRegions = $false
}

New-MgIdentityConditionalAccessNamedLocation -BodyParameter $location

#2️⃣ Criar policy bloqueando outros países
$params = @{
    displayName = "Bloquear Acesso Fora do Brasil"
    state = "enabled"
    conditions = @{
        users = @{
            includeUsers = @("All")
        }
        locations = @{
            includeLocations = @("All")
            excludeLocations = @("Brasil")
        }
        applications = @{
            includeApplications = @("All")
        }
    }
    grantControls = @{
        operator = "OR"
        builtInControls = @("block")
    }
}

New-MgIdentityConditionalAccessPolicy -BodyParameter $params
