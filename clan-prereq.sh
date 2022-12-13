#!/bin/bash -e
# Install dotnet
root=$(pwd)
echo ""

function detect_OS_ARCH_VER_BITS {
    ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

    if [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
    fi

    if ! [ "$DISTRIB_ID" = "" ]; then
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        OS=Debian  # XXX or Ubuntu??
        VER=$(cat /etc/debian_version)
        SVER=$( grep -oP "[0-9]+" /etc/debian_version | head -1 )
    elif [ -f /etc/centos-release ]; then
        OS=CentOS
        VER=$( grep -oP "[0-9]+" /etc/centos-release | head -1 )
    elif [ -f /etc/fedora-release ]; then
        OS=Fedora
        VER=$( grep -oP "[0-9]+" /etc/fedora-release | head -1 )
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$NAME" = "" ]; then
          OS=$(uname -s)
          VER=$(uname -r)
        else
          OS=$NAME
          VER=$VERSION_ID
        fi
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    case $(uname -m) in
    x86_64)
        BITS=64
        ;;
    i*86)
        BITS=32
        ;;
    armv*)
        BITS=32
        ;;
    *)
        BITS=?
        ;;
    esac
    case $(uname -m) in
    x86_64)
        ARCH=x64  # or AMD64 or Intel64 or whatever
        ;;
    i*86)
        ARCH=x86  # or IA32 or Intel32 or whatever
        ;;
    *)
        # leave ARCH as-is
        ;;
    esac
}

declare OS ARCH VER BITS

detect_OS_ARCH_VER_BITS

export OS ARCH VER BITS

if [ "$OS" = "Ubuntu" ]; then
    supported_ver=("16.04" "18.04" "20.04" "21.04" "21.10" "22.04")

    if [[ "${supported_ver[*]}" =~ ${VER} ]]; then
        supported=1
    else
        supported=0
    fi
fi

if [ "$OS" = "LinuxMint" ]; then
    SVER=$( echo $VER | grep -oP "[0-9]+" | head -1 )
    supported_ver=("19" "20")

    if [[ "${supported_ver[*]}" =~ ${SVER} ]]; then
        supported=1
    else
        supported=0
    fi
fi

if [ "$supported" = 0 ]; then
    echo -e "Your OS $OS $VER $ARCH looks unsupported to run ClanBot. \nExiting..."
    printf "\e[1;31mContact ClanBot's support on Discord with screenshot.\e[0m\n"
    rm clan-prereq.sh
    exit 1
fi

if [ "$OS" = "Linux" ]; then
    echo -e "Your OS $OS $VER $ARCH probably can run ClanBot. \nContact ClanBot's support on Discord with screenshot."
    rm clan-prereq.sh
    exit 1
fi

echo "This installer will download all of the required packages for ClanBot. It will use about 350MB of space. This might take awhile to download if you do not have a good internet connection.\n"
echo -e "Would you like to continue? \nYour OS: $OS \nOS Version: $VER \nArchitecture: $ARCH"

while true; do
    read -p "[y/n]: " yn
    case $yn in
        [Yy]* ) clear; echo Running ClanBot Auto-Installer; sleep 2; break;;
        [Nn]* ) echo Quitting...; rm clan-prereq.sh && exit;;
        * ) echo "Couldn't get that please type [y] for Yes or [n] for No.";;
    esac
done

echo ""

if [ "$OS" = "Ubuntu" ]; then
    if [ "$VER" = "21.04" ]; then
        echo -e "*Ubuntu 21.04 has reached an End Of Life (EOL) on January 20, 2022. For more information, see the official Ubuntu EOL page. For now, ClanBot will be supported but it is advised you upgrade to another version."
    fi
    echo "Installing NodeJS"
    sudo apt-get update;
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm install 16.17.1
    nvm use node

    echo "Installing Pnpm..."
    sudo npm install -g pnpm

    echo "Installing Git, PM2, Screen..."
    sudo apt-get install git pm2 screen -y
elif [ "$OS" = "Debian" ]; then
    echo "Installing NodeJS"
    sudo apt-get update;
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm install 16.17.1
    nvm use node

    echo "Installing Pnpm..."
    sudo npm install -g pnpm
    
    echo "Installing Git, PM2, Screen..."
    sudo apt-get install git pm2 screen -y
elif [ "$OS" = "Fedora" ]; then
    sudo dnf install curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm install 16.17.1
    nvm use node

    echo "Installing Pnpm..."
    sudo npm install -g pnpm

    echo "Installing Git, PM2, Screen..."
    sudo dnf install git pm2 screen -y
elif [ "$OS" = "openSUSE Leap" ] || [ "$OS" = "openSUSE Tumbleweed" ]; then
    echo -e "Installing NodeJS..."
    sudo zypper install curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm install 16.17.1
    nvm use node

    echo -e "\nInstalling Pnpm..."
    sudo npm install -g pnpm

    echo "Installing Git, PM2, Screen..."
    sudo zypper install git pm2 screen -y
elif [ "$OS" = "CentOS" ]; then
    if [ "$VER" = "7" ]; then
        echo "Installing NodeJS"
        sudo apt-get update;
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        nvm install 16.17.1
        nvm use node

        echo "Installing Pnpm..."
        sudo npm install -g pnpm

        echo "Installing Git, PM2, Screen..."
        sudo apt-get install git pm2 screen -y
    elif [ "$VER" = "8" ]; then
        echo -e "*CentOS 8 has reached an End Of Life (EOL) on December 31st, 2021. For more information, see the official CentOS Linux EOL page. Because of this, ClanBot won't be supported on CentOS Linux 8."
        rm clan-prereq.sh
        exit 1
    else
        echo -e "Your OS $OS $VER $ARCH probably can run ClanBot. \nContact ClanBot's support on Discord with screenshot."
        rm clan-prereq.sh
        exit 1
    fi
elif [ "$OS" = "LinuxMint" ]; then
    echo "Installing NodeJS"
    sudo apt-get update;
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm install 16.17.1
    nvm use node

    echo "Installing Pnpm..."
    sudo npm install -g pnpm

    echo "Installing Git, PM2, Screen..."
    sudo apt-get install git pm2 screen -y
fi

echo
echo "ClanBot Prerequisites Installation completed..."
read -n 1 -s -p "Press any key to continue..."
sleep 2

cd "$root"
rm "$root/clan-prereq.sh"
exit 0
