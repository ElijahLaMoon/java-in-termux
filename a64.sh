#!/data/data/com.termux/files/usr/bin/bash

#Setup
shopt -s expand_aliases
alias ee='echo -e'

#Greetings
echo
ee "\e[93mThis script will install openjdk-11 in Termux."
ee "\e[93mLibraries compiled and  scripted by \e[32mMrAdityaAlok."
echo

#Checking for existing Java installation
if [ -e "$PREFIX"/bin/java ] || [ -e "$PREFIX"/share/openjdk-11.0.1/bin/java ] || [ -e "$PREFIX"/share/jdk8/bin/java ]
then
	ee "\e[32mJava is already installed!"
	java --version
	echo
	exit
else
	archname=$(dpkg --print-architecture)
	tag="v1.0.0"
	ex="tar.gz"
	file="openjdk-11.0.1"
	
	#Actual installation
	ee "\e[32m[*] \e[34mInstalling openjdk-11 for ${archname}..."
	ee "\e[32m[*] \e[34mPleae wait for some time....\e[0m"

	pkg install wget -y
	wget https://github.com/MrAdityaAlok/java-in-termux/releases/download/"$tag"/openjdk-11."$ex"
	wgetreturn=$?
	if [[ $wgetreturn -eq 0 ]]
	then
        ee "\e[32m[*] \e[34mMoving JDK to system..."
    	mv openjdk-11."$ex" "$PREFIX"/share
	
    	ee "\e[32m[*] \e[34mExtracting JDK to ""$PREFIX""/share "
    	cd "$PREFIX"/share || exit
    	pkg install tar unzip -y
    	tar -xvf openjdk-11."$ex"
    	
    	ee "\e[32m[*] \e[34mSeting-up environment variable %JAVA_HOME%..."
    	export JAVA_HOME="$PREFIX"/share/"$file"
    	echo "export JAVA_HOME=""$PREFIX""/share/""$file"" " >> "$HOME"/.profile
    	PATH=$PATH:"$PREFIX"/share/"$file"/bin
    	echo "PATH=$PATH:""$PREFIX""/share/""$file""/bin" >> "$HOME"/.profile
    	cd "$HOME" || exit
    	
    	ee "\e[32m[*] \e[34mCleaning up temporary files..."
    	rm -rf "$PREFIX"/share/openjdk-11."$ex"
    
    	
    	echo
    	ee "\e[32mJava was successfully installed!"
    	ee "Check it by running \e[34mjava --version from terminal\e[0m"
	ee "\e[32m Note : You must restart termux by exiting or start a new instance of termux, in order to load java command \e[0m"
    	echo
    else 
        echo
        ee "\e[31mwget exited with an error code : $wgetreturn"
        case $wgetreturn in
        1)d
            ee "\e[31mError : Generic code error\e[0m"
            ;;
        2)
            ee "\e[31mError : Parse error-for instance, when parsing command-line options, the .wgetrc or .netrc...\e[0m"
            ;;
        3)
            ee "\e[31mError : File I/O error.\e[0m"
            ;;
        4)
            ee "\e[31mError : Network failure.\e[0m"
            ;;
        5)
            ee "\e[31mError : SSL verification failure.\e[0m"
            ;;
        6)
            ee "\e[31mError : Username/password authentication failure\e[0m"
            ;;
        7)
            ee "\e[31mError : Protocol errors.\e[0m"
            ;;
        8) 
            ee "\e[31mError : Server issued an error response.\e[0m"
            ;;
        esac
        
        rm -rf openjdk-11."$ex"
        echo
        exit
    fi
        
fi
