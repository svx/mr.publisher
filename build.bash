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
  echo "${rev}-all${reset}     --Build Docs and docsets for all versions${reset}."
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
else .
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

# Building docset for Plone 4
function docset4()
{
    cd Plone4 && { doc2dash -n Plone4 --icon dash/icon.png build/html/en ; cd -;}
    rm Plone4/Plone4.docset/Contents/Info.plist
    cd Plone4/Plone4.docset && { curl -o Info.plist https://raw.githubusercontent.com/plone/papyrus/master/dash/Plone4-Info.plist ; cd -; }
    cd Plone4.docset/Contents/Resources/Documents && { curl -O https://raw.githubusercontent.com/plone/papyrus/master/dash/icon.png ; cd -; }
    cd Plone4 && { tar --exclude='.DS_Store' -cvzf Plone4.tgz Plone4.docset ; cd -;}
    ./build_plone4_xml.bash
}

# Building docset for Plone 3
function docset3()
{
    cd Plone3 && { doc2dash -n Plone3 --icon dash/icon.png build/html/en ; cd -;}
    rm Plone3/Plone3.docset/Contents/Info.plist
    cd Plone3/Plone3.docset && { curl -o Info.plist https://raw.githubusercontent.com/plone/papyrus/master/dash/Plone3-Info.plist ; cd -; }
    cd Plone3.docset/Contents/Resources/Documents && { curl -O https://raw.githubusercontent.com/plone/papyrus/master/dash/icon.png ; cd -; }
    cd Plone3 && { tar --exclude='.DS_Store' -cvzf Plone3.tgz Plone3.docset ; cd -;}
    ./build_plone3_xml.bash
}

# Building Plone 4 docs for docker
function docs4_docker()
{
    cd Plone4
    ./bin/sphinx-build -c ../docker/plone4/ -j4 -b html source/documentation build/html/docker
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
        docset3
        ;;
    -p4|--plone4)
        builddate
        build4
        docset4
        ;;
     -d|--docker)
        build_docker_ct
        ;;
    -a|--all)
        builddate
        build3
        docset3
        build4
        docset4
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
