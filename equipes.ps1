########################### Script de création d'équipe automatique #########################
# Langage : Powershell                                                                      #
# Date : 28 octobre 2024                                                                    #
# Création: Gabriel Gaudreault                                                              #
#############################################################################################

# Deux paramètres obligatoires: 
# 1 - La variable $Path représentant le fichier CSV qu'on importe.
# 2 - La variable $Equipede représentant combien de membres par équipe nous souhaitons avoir.
Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline)]
    [string]$Path,
    [Parameter(Position=1,Mandatory=$true,ValueFromPipeline)]
    [int]$Equipede
)

# Importation du fichier CSV
# Le fichier CSV doit posséder les en-têtes "Nom" et "Prenom" sans accent.
# Les champs doivent être délimités par le caractère ";"
# Exemple:
# Nom;Prenom
# Gaudreault;Gabriel
# Gratton;Bob
# etc...

$csv = Import-Csv -Path $Path -Delimiter ';'

# On détermine combien d'élèves nous avons à placer en tout dans la variable $NbEleves
$NbEleves = $csv | Measure-Object | Select-Object -ExpandProperty Count

# On détermine combien d'équipe "pleine" nous serons capable de créer en divisant le nombre d'élèves
# par le nombre de membres désirés dans chaque équipe.
$NbEquipes = [math]::Round($NbEleves / $Equipede,0)

# On vérifie la présence d'un modulo supérieur à zéro. Cela indiquerait qu'il y aura une équipe incomplète
# en fin de script. Ce sera à l'enseignant de déterminer ce qu'il fait de cette équipe.
$Modulo = $NbEleves % $Equipede

# Si un modulo supérieur à zéro est trouvé, nous devons ajouter une équipe, même si celle-ci ne sera pas complète.
if($Modulo -ne 0){
    $NbEquipes++
}

# On démarre une boucle "For" qui s'exécutera pour chaque équipe. Si nous avons déterminé que nous aurons besoin
# de 17 équipes, la boucle s'exécutera 17 fois.
For($ii=0;$ii -lt $NbEquipes; $ii++){

# On inscrit une petite en-tête pour identifier l'équipe
Write-Host "`nÉquipe $($ii + 1) :" -ForegroundColor yellow

    # J'utilise une seconde boucle qui s'exécutera pour chaque membre de l'équipe. Si nous avons déterminé qu'il
    # y a 3 membres par équipe, la boucle s'exécutera 3 fois.
    For($i=0;$i -lt $Equipede; $i++){

        # On inscrit une condition qui valide que notre variable $csv n'est pas vide. Pourquoi ? Parce qu'à chaque
        # fois qu'un membre sera ajouté à une équipe, il ne doit plus être disponible. C'est pourquoi à chaque tour
        # de cette boucle, nous retirerons le candidat de la liste des candidats potentiels. Si la liste est vide, 
        # nous devons arrêter la création d'équipe. C'est pourquoi la condition valide que la variable n'est pas
        # vide avant de poursuivre.
        if($csv -ne $null){

            # On demande à Powershell de sélectionner un candidat au hasard dans le CSV que nous stockons dans la
            # variable $Selection.
            $Selection = Get-Random -InputObject $csv

            # On inscrit le membre en question à l'écran.
            Write-Host "$($Selection.Prenom) $($Selection.Nom)"

            # On retire finalement le membre de la liste des candidats potentiels pour qu'il ne puisse plus
            # être sélectionné.
            $csv = $csv | Where-Object { $_ -notcontains $Selection }
        
        # Dans le cas ou la liste des candidats est épuisée, on sort de la boucle..
        } else {
            break;
        }

    }
}
