#!/bin/bash
PROGNAME=$(basename $0)
# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
#echo "${red}red text ${green}green text${reset}"


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

echo "${green}Checking dependencies${reset}"
check_venv

# If dir exists remove them
function remove_old()
{
    echo "${green}First check for old docs ${reset}"

    echo "Check for Plone4"
    if [ -d "DocsPlone4" ]; then
        echo "Deleting old docs for 4"
        rm -rf DocsPlone4
    fi

    echo "Check for Plone3"
    if [ -d "DocsPlone3" ]; then
        echo "Deleting old docs for 3"
        rm -rf DocsPlone3
    fi
}

# Clean the screen
clear

echo "${green}We are starting the build process - please be patient ${reset}"
echo "${green}Start with fresh checkouts${reset}"

function build4()
{
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
    echo "${green}Checkout Docs for Plone 3${reset}"
    git clone git@github.com:plone/papyrus --branch 3.3 --single-branch DocsPlone3
    echo "${green}Switching into DocsPlone3 and starting the build ${reset}"
    cd DocsPlone3
    python bootstrap-buildout.py
    bin/buildout
    ./get_external_doc.sh
    make html
}


remove_old
build4
build3

# Tell us how long it took
trap times EXIT

# Todo:
# - add error function
# - add log
# - better messages

