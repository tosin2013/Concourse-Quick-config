#!/bin/bash
function boshdependencies() {
    ###
    # Check for bbl and install if not on system
    ###
    FULLPATH=$(pwd)
    CHECKBBL=$(bbl -h 2>/dev/null | grep Usage)
    LINUXCHECK="$(expr substr $(uname -s) 1 5)"
    if [[ -z $CHECKBBL ]]; then
        echo "installing bbl"
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "MAC"
            curl -LO https://github.com/cloudfoundry/bosh-bootloader/releases/download/v6.7.1/bbl-v6.7.1_osx
            chmod +x bbl-v6.7.1_osx
            mv bbl-v6.7.1_osx bbl
            sudo mv bbl /usr/local/bin/bbl
            bbl 2>/dev/null || exit 1
        elif [[  $LINUXCHECK == "Linux" ]]; then
            curl -LO https://github.com/cloudfoundry/bosh-bootloader/releases/download/v6.7.1/bbl-v6.7.1_linux_x86-64
            chmod +x bbl-v6.7.1_linux_x86-64
            mv bbl-v6.7.1_linux_x86-64 /usr/local/bin/bbl
            bbl 2>/dev/null || exit 1
        elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
            echo "MINGW32_NT"
        exit 0
        elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]]; then
            echo "MINGW64_NT"
            exit 0
        fi
    fi

    ###
    ## check if bosh is running on machine
    ###
    BOSHCHECK=$(bosh -h 2>/dev/null | grep Usage)
    if [[ -z $BOSHCHECK ]]; then
        echo "installing bosh"
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "MAC"
            curl -LO https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-3.0.1-darwin-amd64
            chmod +x bosh-cli-*
            echo "Moving bosh-cli-*  /usr/local/bin/bosh please enter password to complete. "
            sudo mv bosh-cli-*  /usr/local/bin/bosh
            bosh -h | grep Usage  || exit 1
            elif [[  $LINUXCHECK == "Linux" ]]; then
                curl -LO https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-3.0.1-linux-amd64
                chmod +x bosh-cli-*
                if [[ $EUID -ne 0 ]]; then
                    sudo mv bosh-cli-* /usr/local/bin/bosh
                else
                    mv bosh-cli-* /usr/local/bin/bosh
                fi
            bosh -h | grep Usage || echo "Fix this issue"
            elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
                echo "MINGW32_NT"
                exit 0
            elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]]; then
                echo "MINGW64_NT"
                exit 0
            fi
        fi

    ###
    ## check if bosh is running on machine
    ###
    DIRENVCHECK=$(direnv 2>/dev/null)
    if [[ -z $DIRENVCHECK ]]; then
        echo "installing direnv"
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "MAC"
        curl -LO https://github.com/direnv/direnv/releases/download/v2.17.0/direnv.darwin-amd64
        chmod +x direnv.darwin-amd64
        echo "Moving direnv.darwin-amd64  /usr/local/bin/direnv please enter password to complete. "
        sudo mv direnv.darwin-amd64  /usr/local/bin/direnv
        echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
        elif [[  $LINUXCHECK == "Linux" ]]; then
            curl -LO https://github.com/direnv/direnv/releases/download/v2.17.0/direnv.linux-amd64
            chmod +x direnv.linux-amd64
            if [[ $EUID -ne 0 ]]; then
                sudo mv direnv.linux-amd64 /usr/local/bin/direnv
                sudo 'eval "$(direnv hook bash)"' >>  ~/.bashrc
            else
                mv direnv.linux-amd64 /usr/local/bin/direnv
                echo 'eval "$(direnv hook bash)"' >>  ~/.bashrc
            fi

        elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
            echo "MINGW32_NT"
            exit 0
        elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]]; then
            echo "MINGW64_NT"
            exit 0
        fi
    fi
}
