# PowerShell IdoIt / PsIdoIt

[![Build status](https://ci.appveyor.com/api/projects/status/4cnlvi5audnvxxt5/branch/dev?svg=true)](https://ci.appveyor.com/project/backbone2k/psidoit)

is an [i-doit](https://www.i-doit.com/) API implementation written in PowerShell as a module.

The module will consists of two parts:
1. Core - Implementation of all native api endpoints that are provided by i-doit
    - Login
    - Requests
    - Searching
    - Getting object information by id
    - creating, altering, deleting, archiving, quickpurging objects
    - reports
2. Extending to set of easy to use functions that cover most of the day to day administrative use

The second part is not implemented yet. The focus is on a robust base implementation that leverages all the benefits of PowerShell in a single module.

## Installation

If you are using PowerShell 5 or have NuGet installed you can installing PsIdoIt by simply entering

```
PS> Install-Module PsIdoIt
```

in an elevated PowerShell session. Alternative you can git clone the repository and copy the PsIdoIt folder with all it contents into your module directory.

## Usage

I will provide some basic usage and also some example ps1 scripts as soon as the core modules are in a good shape, documentation is complete and functional and unit
tests are in place.


