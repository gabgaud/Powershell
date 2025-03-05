#Script de correction de l'exercice 01 sous Windows 11
#Conception et production Gabriel Gaudreault 2025

function Write-Correction {
    param (
        [boolean] $IsError 
    )

    if($IsError -eq $true){
        Write-Host "Erreur!" -ForegroundColor Red
    } else {
        Write-Host "Ok!" -ForegroundColor Green
    }
}

function Check-RegistryValue {
    param (
        [string] $Path,
        [string] $TargetValue
    )

    $RegValue = Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $TargetValue
    return $RegValue
}

#Vérification du numéro 1
Write-Host "Correction de la question #1: " -ForegroundColor Yellow -NoNewline
if($(Check-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -TargetValue "TaskbarAl")-eq 0){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 2
$IconesManquantes = $false
Write-Host "Correction de la question #2: " -ForegroundColor Yellow -NoNewline
$IconArray = @("{20D04FE0-3AEA-1069-A2D8-08002B30309D}","{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}","{59031a47-3f72-44a7-89c5-5595fe6b30ee}")
foreach ($icon in $IconArray){
    if ($(Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel | Select-Object -ExpandProperty $icon) -ne 0){
        Write-Correction -IsError $true
        $IconesManquantes = $true
        break;
    }
}
if($IconesManquantes -ne $true){
    Write-Correction -IsError $false
}

#Vérification du numéro 3
Write-Host "Correction de la question #3: " -ForegroundColor Yellow -NoNewline
if($(Check-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -TargetValue "HideFileExt" ) -eq 0){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 4
Write-Host "Correction de la question #4: " -ForegroundColor Yellow -NoNewline
if($(Check-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -TargetValue "ShowRecent") -eq 0){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 5 et 6
$DossiersManquants = $false
$FichiersManquants = $false
Write-Host "Correction des questions #5 et #6: " -ForegroundColor Yellow -NoNewline
$DossiersCréés = @("C:\Jeux", "C:\Travaux", "C:\Jeux\Overwatch", "C:\Jeux\Solitaire", "C:\Travaux\Littérature", "C:\Travaux\Mathématiques", "C:\Travaux\Mathématiques\Algèbre")
$FichiersCréés = @("C:\Jeux\Overwatch\Gameplay.mp4", "C:\Jeux\Overwatch\Overwatch.exe", "C:\Jeux\Solitaire\célibat.mp3", "C:\Travaux\Littérature\Roman.txt", "C:\Travaux\Mathématiques\Exercice_Trigonométrie.txt","C:\Travaux\Mathématiques\Statistiques.txt")
$DossiersCréés | ForEach-Object {
    if (!(Test-Path -Path $_)){
        $DossiersManquants = $true
    }
}
$FichiersCréés | ForEach-Object {
    if (!(Test-Path -Path $_ -PathType Leaf)){
        $FichiersManquants = $true
    }
}
if($DossiersManquants -eq $true -or $FichiersManquants -eq $true){
    Write-Correction -IsError $true
} else {
    Write-Correction -IsError $false
}

#Vérification du numéro 7
Write-Host "Correction de la question #7: " -ForegroundColor Yellow -NoNewline
$CheminRaccourci = $env:USERPROFILE + "\Desktop\Calculatrice.lnk"
if(Test-Path $CheminRaccourci -PathType Leaf){
    $WscriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WscriptShell.CreateShortcut($CheminRaccourci)
    if ($Shortcut.TargetPath -eq "C:\Windows\System32\calc.exe"){
        Write-Correction -IsError $false
    } else {
        Write-Correction -IsError $true
    }
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 8
Write-Host "Correction de la question #8: " -ForegroundColor Yellow -NoNewline
$NetworkAdapterName = Get-NetAdapter | Select-Object -ExpandProperty Name
if($NetworkAdapterName -eq "Local"){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 9
Write-Host "Correction de la question #9: " -ForegroundColor Yellow -NoNewline
if($env:COMPUTERNAME -eq "W11"){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 10
Write-Host "Correction de la question #10: " -ForegroundColor Yellow -NoNewline
$CheminFichierEspace = $env:USERPROFILE + "\Desktop\espace.txt"
$FichierEspace = Get-Content -Path $CheminFichierEspace
$Espace = $FichierEspace -split {$_ -eq "G" -or $_ -eq "g"}
$EspaceInt = [int]$Espace[0]
if($Espace -gt 30 -and $Espace -lt 40){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 11
Write-Host "Correction de la question #11: " -ForegroundColor Yellow -NoNewline
if($(Check-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -TargetValue "ToastEnabled") -eq 0){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}

#Vérification du numéro 12
Write-Host "Correction de la question #12: " -ForegroundColor Yellow -NoNewline
$OneDriveStartup = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run | Select-Object -ExpandProperty OneDrive
if($OneDriveStartup[0] -eq 3){
    Write-Correction -IsError $false
} else {
    Write-Correction -IsError $true
}


#Fin
Write-Host -NoNewLine 'Appuyez sur une touche pour continuer...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');