# FITHELPER

Script for school work management on FIT CTU. This is hobby project, so don't expect anything extra.

## Usage

```
Usage: fithelper [OPTION]
Helper script for CVUT FIT students

Options:
  gui               Display GUI
  mount             Enable vpn and connect to faculty drive
  unmount           Unmount drive and disable vpn
  csap              Copy files from SAP to local dir
  allsap            Do everything for SAP
  syncgit           Commit and push to repo
  cpa2              Copy PA2 folder to faculty repo
  syncgitpa2        Commit and push PA2 to faculty repo
  allpa2            Do both above
  psi               Copy PSI semester work to local dir
  everything        DANGEROUS! DOES EVERYTHING!
  help              Display this help and exit
  display_config     Display config
  version           Display version

If there is any problem, please report it on github: https://github.com/Hikari03/fithelper
Before doing so, try running "fithelper display_config" and check if your config is correct
If you are using GUI, try CLI commands first, as they display errors in more readable way
Also, if you have any idea for new feature, feel free to open issue
```


## Instalation

### Prerequisities

If you want to use GUI, make sure you have `dialog` installed.

### Setup

 - Download whole repository (using git clone).
 - Run `setup.sh` script and follow instructions
