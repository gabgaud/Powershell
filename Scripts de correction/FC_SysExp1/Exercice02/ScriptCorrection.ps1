# Script de correction pour Exercice 02
# Conception Gabriel Gaudreault 2025

#Fonction qui permet de rechercher certaines commandes dans l'historique des commandes
function Check-History {
    param(
        [string[]] $Values,
        [string] $Operator
    )
    $Historique = Get-Content -Path $env:USERPROFILE\Desktop\Exercice02.json | ConvertFrom-Json
    $Query = $null
    foreach($Value in $Values){
        if($Query -eq $null){
            $Query += "`$_.Commandline $Operator '$Value'"
        } else {
            $Query += " -or `$_.Commandline $Operator '$Value'"
        }
    }

    $Answer = "Erreur!"

    $Historique | ForEach-Object{
        if(Invoke-Expression $Query){
            $Answer = "Ok!"
        }
    }
    if($Answer -eq "Ok!"){
        $Answer = Write-Host "Ok!" -ForegroundColor Green
        Return $Answer
    } else {
        $Answer = Write-Host "Erreur!" -ForegroundColor Red
        Return $Answer
    }
}

#Fonction permettant de vérifier l'existence d'un fichier, un dossier ou une clé de registre
function Check-Exist {
    param(
        [Parameter(Mandatory)]
        [string] $Type,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [boolean] $Reverse
    )

    $Response = $false
    switch ($Type) {
        File {
            $Path += $Name
            if(Test-Path -Path $Path -PathType Leaf){
                $Response = $true
            }
            if($Reverse -eq $true){
                $Response = !$Response
            }
            Return $Response
        }
        Folder {
            $Path += $Name
            if(Test-Path -Path $Path -PathType Container){
                $Response = $true
            }
            if($Reverse -eq $true){
                $Response = !$Response
            }
            Return $Response
        }
    }
}

function Out-Correction {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [Boolean] $Valeur
    )
    if($Valeur -eq $true){
        Write-Host "Ok!" -ForegroundColor Green
    } else {
        Write-Host "Erreur!" -ForegroundColor Red
    }
}

#Question 1
Write-Host "Correction de la question #1: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Set-Location ..",
    "Set-Location C:\"
)
Check-History @Values -Operator "-eq"

#Question 2
Write-Host "Correction de la question #2: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Get-ChildItem",
    "Get-ChildItem C:\"
)
Check-History @Values -Operator "-eq"

#Question 3
Write-Host "Correction de la question #3: " -NoNewline -ForegroundColor Yellow
Check-Exist -Type "Folder" -Path "C:\" -Name "exploitation" -Reverse $false | Out-Correction


#Question 4
Write-Host "Correction de la question #4: " -NoNewline -ForegroundColor Yellow
Check-Exist -Type "File" -Path "C:\Exploitation\" -Name "commandes.txt" -Reverse $true | Out-Correction


#Question 5
Write-Host "Correction de la question #5: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "*commandes.txt*powershell.txt"
)
Check-History @Values -Operator "-like"

#Question 6
Write-Host "Correction de la question #6: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Add-Content*Powershell, c''est fantastique!*",
    "Set-Content*Powershell, c''est fantastique!*"
)
Check-History @Values -Operator "-like"

#Question 7
Write-Host "Correction de la question #7: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Set-Content*Mon prof est incroyable!*"
)
Check-History @Values -Operator "-like"

#Question 8
Write-Host "Correction de la question #8: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Copy-Item*C:\exploitation*-Recurse"
)
Check-History @Values -Operator "-like"


#Question 9
Write-Host "Correction de la question #9: " -NoNewline -ForegroundColor Yellow
Check-Exist -Type "Folder" -Path "$env:USERPROFILE\Desktop\" -Name "Exercice" -Reverse $false | Out-Correction


#Question 10
Write-Host "Correction de la question #10: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Remove-Item*Powershell.txt"
)
Check-History @Values -Operator "-like"

#Question 11
Write-Host "Correction de la question #11: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Write-Host*-Foregroundcolor green"
)
Check-History @Values -Operator "-like"

#Question 12
Write-Host "Correction de la question #12: " -NoNewline -ForegroundColor Yellow
$Values = @(
    "Clear-Host"
)
Check-History @Values -Operator "-eq"