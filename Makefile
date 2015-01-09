# Vars
SHELL := /bin/bash
VENV=.

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# #echo "${red}red text ${green}green text${reset}"

.PHONY: bootstrap

bootstrap:
	@echo "${green}>>> Bootstraping mr.publisher, please hold on${reset}"
	@echo "${green}>>> Creating virtualenv${reset}"
	virtualenv --python=python2.7 --no-site-packages $(VENV)

	@echo -e "${green}>>> Install dependencies...${reset}"
	bash -c "source bin/activate && pip install -r requirements.txt"
