#!/bin/bash
function check_vagrant_plugins()
{
# Check if all needed vagrant plugins all installed
PLUGINS='vagrant-hostsupdater vagrant-vbguest'
for plugin in $PLUGINS; do
    if vagrant plugin list | grep -q "$plugin"
        then
            echo "${green} $plugin is installed ${reset}"
        else
            echo "${green} Installing $plugin ${reset}"
            vagrant plugin install $plugin
        fi
done
}
