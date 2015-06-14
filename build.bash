#!/bin/bash

PROGNAME=$(basename $0)
# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`
rev=`tput smso`
#echo "${red}red text ${green}green text${reset}"

## Settings
# Reset all variables that might be set
file=
verbose=0


## FUNCTIONS
# help function
function HELP ()
{
  echo -e \\n"Help documentation for mr.publisher${reset}"\\n
  echo -e "${rev}Basic usage:${reset} ${bold}build.bash -plone4${reset}"\\n
  echo "Command line switches are optional. The following switches are recognized."
  echo "${rev}-plone3${reset}  --Build Plone 3 Docs and docsets${reset}."
  echo "${rev}-plone4${reset}  --Build Plone 4 Docs and docsets${reset}."
  echo "${rev}-plone5${reset}  --Build Plone 5 Docs and docsets${reset}."
  echo "${rev}-vagrant${reset} --Starts docs.plone.org as vagrant box for finial test${reset}."
  echo "${rev}-docker${reset}  --Build docker container${reset}."
  echo -e "${rev}-h${reset}       --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${bold}$PROGNAME -plone4${reset}"\\n
  exit 1
}

# error function
function error_exit ()
{

#   ----------------------------------------------------------------
#   Function for exit due to fatal program error
#       Accepts 1 argument:
#           string containing descriptive error message
#   ----------------------------------------------------------------


    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

# Example call of the error_exit function.  Note the inclusion
# of the LINENO environment variable.  It contains the current
# line number.

# First check if we can detect a venv, if yes continue, if not stop with  error
function check_venv ()
{
if [[ -z $VIRTUAL_ENV ]]; then
    error_exit "$LINENO":"${red}Please make sure that virtualenv is installed and activated${reset}"
else :
fi
}

# Check if we can detect a virtualenv
#echo "${green}Checking dependencies${reset}"
#check_venv

# Clean the screen
clear

function builddate()
{
    # Date format is Year-Month-Day
    DATE=`date +%Y%m%d`
    echo "${green}Check for version file${reset}"
    if [ -d "version.txt" ]; then
        rm version.txt
    fi
    echo ""$DATE"" > version.txt
}

# Building HTML docs for Plone 5
function build5()
{
    echo "${green}Check for Plone 5${reset}"
    if [ -d "Plone4" ]; then
        echo "${green}Deleting old Plone 5 docs${reset}"
        rm -rf Plone4
    fi
    echo "${green}Checkout Docs for Plone 5${reset}"
    git clone git@github.com:plone/papyrus --branch 5.0 --single-branch Plone5
    echo "${green}Switching into DocsPlone4 and starting the build ${reset}"
    cd Plone5 && { python bootstrap-buildout.py ; bin/buildout ; ./get_external_doc.sh ; make html ; cd -;  }
}

# Building HTML docs for Plone 4
function build4()
{
    echo "${green}Check for Plone 4${reset}"
    if [ -d "Plone4" ]; then
        echo "${green}Deleting old Plone 4 docs${reset}"
        rm -rf Plone4
    fi
    echo "${green}Checkout Docs for Plone 4${reset}"
    git clone git@github.com:plone/papyrus --branch master --single-branch Plone4
    echo "${green}Switching into DocsPlone4 and starting the build ${reset}"
    cd Plone4 && { python bootstrap-buildout.py ; bin/buildout ; ./get_external_doc.sh ; make html ; cd -;  }
}

# Building HTML docs for Plone 3
function build3()
{
    echo "${green}Check for Plone 3${reset}"
    if [ -d "Plone3" ]; then
        echo "${green}Deleting old Plone 3 docs${reset}"
        rm -rf Plone3
    fi
    echo "${green}Checkout Docs for Plone 3${reset}"
    git clone git@github.com:plone/papyrus --branch 3.3 --single-branch Plone3
    echo "${green}Switching into DocsPlone3 and starting the build ${reset}"
    cd Plone3 && { python bootstrap-buildout.py ; bin/buildout ; ./get_external_doc.sh ; make html ; cd -;  }
}

# Building Plone 4 docs for docker
function docs4_docker()
{
    cd Plone4
    ./bin/sphinx-build -c ../docker/plone4/ -j4 -b html source/documentation build/html/docker
}

# Building Plone 5 docs for docker
function docs5_docker()
{
    cd Plone5
    ./bin/sphinx-build -c ../docker/plone5/ -j4 -b html source/documentation build/html/docker
}

function build_docker_ct ()
{
    ./build_docker.bash
}

# Check the number of arguments. If none are passed, print help and exit.
#NUMARGS=$#
#echo -e \\n"Number of arguments: $NUMARGS"
#if [ $NUMARGS -eq 0 ]; then
#      HELP
#fi

## Arguments
while [ "$#" -gt 0 ]
do
    case "$1" in
    -h|--help)
        HELP
        exit 0
        ;;
    -p3|--plone3)
        builddate
        build3
        ;;
    -p4|--plone4)
        builddate
        build4
        ;;
    -p5|--plone5)
        builddate
        build5
        ;;
     -d|--docker)
        build_docker_ct
        ;;
    -a|--all)
        builddate
        build3
        build4
        build5
        ;;
    --)
        break
        ;;
    *) ;;
    esac
    shift
done


# Tell us how long it took
trap times EXIT
