# Vars
SHELL := /bin/bash
VENV=.

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
#echo "${red}red text ${green}green text${reset}"

.PHONY: bootstrap plone3 plone4 pip-update pip-list

bootstrap:
	@echo "${green}>>> Bootstraping mr.publisher, please hold on${reset}"
	@echo "${green}>>> Creating virtualenv${reset}"
	virtualenv --python=python2.7 --no-site-packages $(VENV)

	@echo -e "${green}>>> Install dependencies...${reset}"
	bash -c "source bin/activate && pip install -r requirements.txt"

plone3:
	@echo "${green}>>> Building docs and docsets for Plone 3${reset}"
	bash -c "source bin/activate && /build.bash --plone3"

plone4:
	@echo "${green}>>> Building docs and docsets for Plone 4${reset}"
	bash -c "source bin/activate && ./build.bash --plone4"

pip-update:
	@echo -e"${green}>>> Upgrading all packes installed with pip${reset}"
	bash -c "source bin/activate && pip-review --auto"

pip-list:
	@echo -e"${green}>>> Creating requirements.txt with all your packages installed by pip${reset}"
	bash -c "source bin/activate && pip-dump"
