#!/bin/bash

ipinstance=localhost

# Vérification du droit d'éxécution du script
if (( $EUID != 0 )); then
    echo "Lancer le script avec la commande sudo, ou avec le compte root"
    exit
fi

# Nettoyage du terminal
clear

# Mise a jours des depots et des paquets
apt update && apt full-upgrade -y

# Installation de Java jdk 11
apt install -y openjdk-11-jdk gnupg

# Ajout du dépot de jenkins et de la clé
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Installation de jenkins
apt update
apt install -y jenkins

# Start Jenkins
systemctl start jenkins

# Enable Jenkins to run on Boot
systemctl enable jenkins

# Affichage du mot de pass à utiliser dans l'interface web
clear
temp_admin_password=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "Le mot de passe pour débloquer Jenkins est le suivant"
echo "$temp_admin_password"
echo "Utiliser le sur http://$ipinstance:8080"
