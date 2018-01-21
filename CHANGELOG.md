#Changelog

##v0.1.0.40 - 01/1x/2018

- Added: wildcard support for parameter title in Get-IdoitObjectByFilter
- Fixed: Error passing Id parameter to Get-IdoItCategory

##v0.1.0.42 - 01/15/2018

- Added: Create a constant cache in the users romaing profile when calling Connect-IdoIt
- Added: DynamicParameter validate set for parameter <Category> that pulls constants from the psidoit cache

##v0.1.0.5x - 01/21/2018

- Added: Get-IdoItCategory and Get-IdoItObject return easyier to understand objects by flattening contained sub-objects
- Improved: Cache handling refractored into seperate functions