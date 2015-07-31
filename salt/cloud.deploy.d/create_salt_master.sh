#!/usr/bin/env bash
##############################################
## --------- Variable Settings ------------ ##
##############################################
## These are the only settings that should need to
## be updated for your deployment needs
#
MASTERS_MINION_ID="salt-master-server"
HOME="/home/ec2-user"
ROOT_HOME="/root"
GIT_BRANCH="testnet_staging"
GIT_REPO_URL="git@bitbucket.org:myaccount/myapp-saltstack.git"
REPO_LOCAL_NAME="myapp-saltstack"
SALT_REPO_ROOT="/opt"
GIT_REPO_KEY_NAME="id_rsa"
#
##############################################
## ----------- Script Begin --------------- ##
##############################################
## Update and Install Packages
yum -y update
yum -y install git patch
yum -y install salt-cloud salt-master salt-minion --enablerepo=epel
## Manage Git Access Key and Clone Salt Repo
cd ${SALT_REPO_ROOT}
cp "${HOME}/${GIT_REPO_KEY_NAME}" "${ROOT_HOME}/.ssh/"
chmod 400 "${ROOT_HOME}/.ssh/${GIT_REPO_KEY_NAME}"
ssh-keyscan bitbucket.org >> "${ROOT_HOME}/.ssh/known_hosts"
git clone -b ${GIT_BRANCH} ${GIT_REPO_URL} ${REPO_LOCAL_NAME}
## Remove Default Salt and Setup SymLinks
rm -rf /etc/salt
rm -rf /srv
ln -s "${SALT_REPO_ROOT}/${REPO_LOCAL_NAME}/salt/" /etc/salt
ln -s "${SALT_REPO_ROOT}/${REPO_LOCAL_NAME}/srv/" /srv
## Apply Patches found in Repo from the root dir to Salt System (makes backups of orig)
cd /
patch -p0 -b < "${SALT_REPO_ROOT}/${REPO_LOCAL_NAME}/extras/patches/__init__.py.patch"
patch -p0 -b < "${SALT_REPO_ROOT}/${REPO_LOCAL_NAME}/extras/patches/key.py.patch"
patch -p0 -b < "${SALT_REPO_ROOT}/${REPO_LOCAL_NAME}/extras/patches/saltmod.py.patch"
## Start Master then Minion Processes (give them time to boot)
service salt-master start
service salt-minion start
sleep 10
## Move Keys to be used by Minions to the Directory in Salt Root
mkdir -p /etc/salt/salt_keys/
mv "${HOME}/*.pem" /etc/salt/salt_keys/
chmod 400 /etc/salt/salt_keys/*.pem
## Salt Master Accept it's own Minion's Key
salt-key -y -a ${MASTERS_MINION_ID}
sleep 3
## Update the Grains so Master/Minion is a Logger Role
salt-call --local grains.append roles saltmaster
sleep 3
salt-call --local grains.append roles logger
sleep 3
salt-call --local grains.append roles kibana
sleep 3
salt '*' saltutil.sync_all
sleep 5
salt-call mine.update
sleep 3
salt '*' mine.update
sleep 3
salt-run state.orch orchestration-create.salt-master-server pillar="{'minion': 'salt-master-server'}"
#salt-call event.send 'salt/cloud/any/master-created' '{name: salt-master-}'
## Call High-State setting up as a Logger, etc..
# salt-call state.highstate