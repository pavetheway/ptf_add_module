#!/bin/bash
# this script will generate a module file for PTF.
clear
echo -e "\e[0;96mPTF Module Generator"
echo -e "\e[0;96mThis script currently only works with GitHub URLs!!!!"
echo -e "\e[0;96mThis script assumes PTF is installed under /opt/ptf!!"
echo ""

echo -e "\e[0;31m------------------------------------------------"
echo -e "\e[0;31mEnter the github URL of the tool:\e[0;39m"
read githuburl
echo ""

#echo "------------------------------------------------"
#echo "Would you like for this tool to be updated automatically with the rest of the tools? (Enter for YES, anything for no)"
#read updatebypasschoice
#if [ -z "$updatebypasschoice" ]; then
#    toolupdatebypass="NO"
#else
#    toolupdatebypass="YES"
#fi

echo -e "\e[0;31m------------------------------------------------"
echo -e "\e[0;31mThe following tool categories were found:\e[0;39m"
cd /opt/ptf/modules
ls -d */ | cut -f1 -d'/'
echo -e "\e[0;31mIn which of the above categories would you like to place this module?\e[0;39m"
read modulecategoryselection
moduleinstalllocation=$(echo "\/opt\/ptf\/modules\/$modulecategoryselection")
echo ""

echo -e "\e[0;31m------------------------------------------------"
echo "After commands are commands that you can insert after an installation. This could be switching to a directory and kicking off additional commands to finish the installation. For example in the BEEF scenario, you need to run ruby install-beef afterwards.  Below is an example of after commands using the {INSTALL_LOCATION} flag."
echo ""
echo "AFTER_COMMANDS=\"cp config/dict/rockyou.txt {INSTALL_LOCATION}\""
echo ""
echo -e "\e[0;31mEnter post-download install commands for the tool, if any.  PTF readme text regarding this is included above as reference.  Separate each command with a single comma:\e[0;39m"
read toolaftercommands

#echo "------------------------------------------------"
#echo "Enter any package dependencies this tool requires.  Separate multiple dependencies with a single comma.  If none, leave blank: "
#read tooldependencies

clear
echo -e "\e[0;31m------------------------------------------------"
echo -e "\e[0;31mDownloading $githuburl page..."
curl -s $githuburl > /tmp/ptf_git_url_tmp
echo ""

echo "Generating module..."
toolname=$(echo "$githuburl" | sed 's/https\:\/\/github\.com\///' | sed 's/\.git//' | awk -F'/' '{print $2}')
toolauthorname=$(echo "$githuburl" | sed 's/https\:\/\/github\.com\///' | sed 's/\.git//' | awk -F'/' '{print $1}')
tooldescription=$(cat /tmp/ptf_git_url_tmp | grep "<span itemprop=" | grep about | sed -e 's/<[^>]*>//g' | sed -e 's/^[ \t]*//')
rm /tmp/ptf_git_url_tmp
sleep 1


echo -e "\e[0;39m"
echo "#!/usr/bin/env python" > /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "#####################################" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "# Installation module for $toolname" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "#####################################" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "AUTHOR=\"$toolauthorname\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "DESCRIPTION=\"$tooldescription\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "INSTALL_TYPE=\"GIT\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "REPOSITORY_LOCATION=\"$githuburl\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo  >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "X64_LOCATION=\"\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo  >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "INSTALL_LOCATION=\"$toolname\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo  >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "DEBIAN=\"$tooldependencies\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo  >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "ARCHLINUX=\"\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo  >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "BYPASS_UPDATE=\"$toolupdatebypass\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo  >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "AFTER_COMMANDS=\"$toolaftercommands\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo  >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo "LAUNCHER=\"\"" >> /opt/ptf/modules/$modulecategoryselection/$toolname.py
echo -e "\e[0;31m------------------------------------------------"
echo -e "\e[0;91m#!/usr/bin/env python"
echo "#####################################"
echo -e "# Installation module for \e[0;96m$toolname"
echo -e "\e[0;91m#####################################"
echo ""
echo -e "AUTHOR=\e[0;96m\"$toolauthorname\""
echo ""
echo -e "\e[0;91mDESCRIPTION=\e[0;96m\"$tooldescription\""
echo ""
echo -e "\e[0;91mINSTALL_TYPE=\e[0;96m\"GIT\""
echo ""
echo -e "\e[0;91mREPOSITORY_LOCATION=\e[0;96m\"$githuburl\""
echo ""
echo -e "\e[0;91mX64_LOCATION=\e[0;96m\"\""
echo ""
echo -e "\e[0;91mINSTALL_LOCATION=\e[0;96m\"$toolname\""
echo ""
echo -e "\e[0;91mDEBIAN=\e[0;96m\"$tooldependencies\""
echo ""
echo -e "\e[0;91mARCHLINUX=\e[0;96m\"\""
echo ""
echo -e "\e[0;91mBYPASS_UPDATE=\e[0;96m\"$toolupdatebypass\""
echo ""
echo -e "\e[0;91mAFTER_COMMANDS=\e[0;96m\"$toolaftercommands\""
echo ""
echo -e "\e[0;91mLAUNCHER=\e[0;96m\"\""
echo ""
echo -e "\e[0;31m------------------------------------------------"
echo -e "\e[0;91mYour module is located at /opt/ptf/modules/$modulecategoryselection/$toolname.py"
read -p "Press enter to edit the module..."
nano /opt/ptf/modules/$modulecategoryselection/$toolname.py