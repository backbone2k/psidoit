#
# Modulmanifest für das Modul "PSGet_psidoit"
#
# Generiert von: Christian Baumgartner
#
# Generiert am: 25.01.2018
#

@{

# Die diesem Manifest zugeordnete Skript- oder Binärmoduldatei.
RootModule = 'PsIdoIt.psm1'

<<<<<<< HEAD
# Die Versionsnummer dieses Moduls
ModuleVersion = '0.1.0.56'
=======
# Version number of this module.
ModuleVersion = '0.1.0.57'
>>>>>>> 3fff5fc60c221c04a6ef70c13682f80ad9ade59d

# Unterstützte PSEditions
# CompatiblePSEditions = @()

# ID zur eindeutigen Kennzeichnung dieses Moduls
GUID = 'ab55d75d-c735-4e3b-80c1-d001bb7bdd60'

# Autor dieses Moduls
Author = 'Christian Baumgartner'

# Unternehmen oder Hersteller dieses Moduls
CompanyName = 'PsIdoIt'

# Urheberrechtserklärung für dieses Modul
Copyright = '(c) 2018 Christian Baumgartner. All rights reserved.'

# Beschreibung der von diesem Modul bereitgestellten Funktionen
Description = 'This is community project that adds PowerShell to the list of i-doit api implementations.'

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Moduls
PowerShellVersion = '3.0'

# Der Name des für dieses Modul erforderlichen Windows PowerShell-Hosts
# PowerShellHostName = ''

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Hosts
# PowerShellHostVersion = ''

# Die für dieses Modul mindestens erforderliche Microsoft .NET Framework-Version. Diese erforderliche Komponente ist nur für die PowerShell Desktop-Edition gültig.
# DotNetFrameworkVersion = ''

# Die für dieses Modul mindestens erforderliche Version der CLR (Common Language Runtime). Diese erforderliche Komponente ist nur für die PowerShell Desktop-Edition gültig.
# CLRVersion = ''

# Die für dieses Modul erforderliche Prozessorarchitektur ("Keine", "X86", "Amd64").
# ProcessorArchitecture = ''

# Die Module, die vor dem Importieren dieses Moduls in die globale Umgebung geladen werden müssen
# RequiredModules = @()

# Die Assemblys, die vor dem Importieren dieses Moduls geladen werden müssen
# RequiredAssemblies = @()

# Die Skriptdateien (PS1-Dateien), die vor dem Importieren dieses Moduls in der Umgebung des Aufrufers ausgeführt werden.
# ScriptsToProcess = @()

# Die Typdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
# TypesToProcess = @()

# Die Formatdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
FormatsToProcess = 'psidoit.Format.ps1xml'

# Die Module, die als geschachtelte Module des in "RootModule/ModuleToProcess" angegebenen Moduls importiert werden sollen.
# NestedModules = @()

# Aus diesem Modul zu exportierende Funktionen. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Funktionen vorhanden sind.
FunctionsToExport = @('Add-IdoItCategory', 'Add-IdoItDialog', 'Connect-IdoIt', 
               'Disconnect-IdoIt', 'Find-IdoItObject', 'Get-IdoItCategory', 
               'Get-IdoItCategoryInfo', 'Get-IdoItConstant', 'Get-IdoItDialog', 
               'Get-IdoItLocationTree', 'Get-IdoItObject', 'Get-IdoItObjectByFilter', 
               'Get-IdoItObjectByRelation', 'Get-IdoItObjectType', 
               'Get-IdoItObjectTypeCategory', 'Get-IdoItObjectTypeGroup', 
               'Get-IdoItReport', 'Get-IdoItVersion', 'New-IdoItConfig', 
               'New-IdoItObject', 'Remove-IdoItCategory', 'Remove-IdoItDialog', 
               'Remove-IdoItObject', 'Set-IdoItCategory', 'Set-IdoItDialog', 
               'Set-IdoItObject')

# Aus diesem Modul zu exportierende Cmdlets. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Cmdlets vorhanden sind.
CmdletsToExport = @()

# Die aus diesem Modul zu exportierenden Variablen
# VariablesToExport = @()

# Aus diesem Modul zu exportierende Aliase. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Aliase vorhanden sind.
AliasesToExport = @()

# Aus diesem Modul zu exportierende DSC-Ressourcen
# DscResourcesToExport = @()

# Liste aller Module in diesem Modulpaket
# ModuleList = @()

# Liste aller Dateien in diesem Modulpaket
# FileList = @()

# Die privaten Daten, die an das in "RootModule/ModuleToProcess" angegebene Modul übergeben werden sollen. Diese können auch eine PSData-Hashtabelle mit zusätzlichen von PowerShell verwendeten Modulmetadaten enthalten.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'I-doIt','Cmdb'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/backbone2k/psidoit/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/backbone2k/psidoit'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable
    
 } # End of PrivateData hashtable

# HelpInfo-URI dieses Moduls
# HelpInfoURI = ''

# Standardpräfix für Befehle, die aus diesem Modul exportiert werden. Das Standardpräfix kann mit "Import-Module -Prefix" überschrieben werden.
# DefaultCommandPrefix = ''

}

