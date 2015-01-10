#!/bin/bash
PROGNAME=`basename ${BASH_SOURCE[0]}
#PROGNAME=$(basename $0)
#SCRIPT=`basename ${BASH_SOURCE[0]}
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
function HELP {
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
function error_exit
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
echo "${green}Checking dependencies${reset}"
check_venv

# Clean the screen
clear

echo "${green}We are starting the build process - please be patient ${reset}"
echo "${green}Start with fresh checkouts${reset}"

function build4()
{
    echo "${green}Check for Plone4${reset}"
    if [ -d "DocsPlone4" ]; then
        echo "${green}Deleting old docs for 4${reset}"
        rm -rf DocsPlone4
    fi
    echo "${green}Checkout Docs for Plone 4${reset}"
    git clone git@github.com:plone/papyrus --branch master --single-branch DocsPlone4
    echo "${green}Switching into DocsPlone4 and starting the build ${reset}"
    cd DocsPlone4
    python bootstrap-buildout.py
    bin/buildout
    ./get_external_doc.sh
    make html
}

function build3()
{
    echo "${green}Check for Plone3${reset}"
    if [ -d "DocsPlone3" ]; then
        echo "${green}Deleting old docs for 3${reset}"
        rm -rf DocsPlone3
    fi
    echo "${green}Checkout Docs for Plone 3${reset}"
    git clone git@github.com:plone/papyrus --branch 3.3 --single-branch DocsPlone3
    echo "${green}Switching into DocsPlone3 and starting the build ${reset}"
    cd DocsPlone3
    python bootstrap-buildout.py
    bin/buildout
    ./get_external_doc.sh
    make html
}

# Check the number of arguments. If none are passed, print help and exit.
#NUMARGS=$#
#echo -e \\n"Number of arguments: $NUMARGS"
#if [ $NUMARGS -eq 0 ]; then
#      HELP
#fi

## Arguments
while [ "$#" -gt 0 ]; do
    case $1 in
        -h|-\?|--help)
            HELP
            exit
            ;;
        -3|-plone3)
            echo "plone3"
            ;;
        -vagrant)
			echo "Vagrant"
			;;
		-docker
			echo "Docker"
			;;
        --)              # End of all options.
            shift
            break
            ;;
        *)
            break
        esac
    shift
done


remove_old
build4
build3

# Tell us how long it took
trap times EXIT

# Todo:
# - add error function
# - add log
# - better messages

