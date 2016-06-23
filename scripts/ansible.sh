#!/bin/bash
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

case $(lsb_release -is) in
    'ubuntu')
        apt-add-repository ppa:ansible/ansible
        apt-get -qy update
        $minimal_apt_get_install ansible
    ;;
    *)
        apt-get -qy install libffi-dev
        easy_install pip
        pip install ansible
    ;;
esac
