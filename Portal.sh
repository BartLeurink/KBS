#!/bin/bash
clear
read -p "Voer nu jouw uniek ID in: " uniek_nummer
if
        [ -d /home/$uniek_nummer ]
then
        echo "Deze user bestaat"
else
        echo "Deze user bestaat niet.."
        echo "User wordt aangemaakt"
        sudo mkdir /home/$uniek_nummer
fi
echo " "
echo " "
echo "Wat wil je doen"
echo "1. Container aanvragen"
echo "2. Container verwijderen"
read -p "Geef taaknummer aan: " choice1
echo " "
echo " "

case $choice1 in
        1)
                echo "Wat voor linux server wil je uitrollen"
                echo "1. Webserver"
                echo "2. Databaseserver"

                read -p "Geef taaknummer aan: " choice2
                case $choice2 in
                        1)
                                if
                                        [ -d /home/$uniek_nummer/Webservers ]
                                then
                                        sudo touch /home/student/selfserviceportal/Webservers_template.yml
                                        sudo chmod 777 /home/student/selfserviceportal/Webservers_template.yml
                                        sudo sed "s/\${uniek_nummer}/$uniek_nummer/g" Webservers.yml > Webservers_template.yml
                                        sudo cp /home/student/selfserviceportal/Webservers_template.yml /home/$uniek_nummer/Webservers
                                else
                                        sudo mkdir /home/$uniek_nummer/Webservers
                                        sudo echo "map Webserver aangemaakt"
                                        sudo touch /home/student/selfserviceportal/Webservers_template.yml
                                        sudo chmod 777 /home/student/selfserviceportal/Webservers_template.yml
                                        sudo sed "s/\${uniek_nummer}/$uniek_nummer/g" Webservers.yml > Webservers_template.yml
                                        sudo cp /home/student/selfserviceportal/Webservers_template.yml /home/$uniek_nummer/Webservers

                                fi

                                echo "Bestanden zijn gekopieerd."

                                kubectl apply -f /home/$uniek_nummer/Webservers/Webservers_template.yml
                                kubectl get deployments
                                kubectl get pods

                                ;;
                        2)
                                if
                                        [ -d /home/$uniek_nummer/Database ]
                                then
                                        sudo touch /home/student/selfserviceportal/Database_template.yml
                                        sudo chmod 777 /home/student/selfserviceportal/Database_template.yml
                                        sudo sed "s/\${uniek_nummer}/$uniek_nummer/g;" Database.yml > Database_template.yml
                                        sudo cp /home/student/selfserviceportal/Database_template.yml /home/$uniek_nummer/Database
                                else
                                        sudo mkdir /home/$uniek_nummer/Database
                                        sudo echo "map Database aangemaakt"
                                        sudo touch /home/student/selfserviceportal/Database_template.yml
                                        sudo chmod 777 /home/student/selfserviceportal/Database_template.yml
                                        sudo sed "s/\${uniek_nummer}/$uniek_nummer/g;" Database.yml > Database_template.yml
                                        sudo cp /home/student/selfserviceportal/Database_template.yml /home/$uniek_nummer/Database

                                fi
                                echo "Bestanden zijn gekopieerd."
                                kubectl apply -f /home/$uniek_nummer/Database/Database_template.yml
                                kubectl get deployments
                                echo ""
                                kubectl get pods
                                echo ""
                                ;;
                        *)
                                echo "Dit is geen keuze."
                esac
                ;; 
       2)
                echo "Welke container wil je verwijderen"
                echo "1. Webserver"
                echo "2. Databaseserver"
                read -p "Geef taaknummer aan: " servertype
                case $servertype in
                        1)
                                if
                                        [ -d /home/$uniek_nummer/Webservers ]
                                then
                                        kubectl delete deployment webserver-deployment-$uniek_nummer
                                        sudo rm -r /home/$uniek_nummer/Webservers
                                        sudo rm -r /home/student/selfserviceportal/Webservers_template.yml
                                        echo ""
                                        kubectl get deployments
                                else
                                        echo "Je hebt geen webservers"
                                fi
                                ;;
                        2)
                                if
                                        [ -d /home/$uniek_nummer/Database ]
                                then
                                        kubectl delete deployment "mysql-container-$uniek_nummer"
                                        sudo rm -r /home/$uniek_nummer/Database
                                        sudo rm -r /home/student/selfserviceportal/Database_template.yml
                                        echo ""
                                        kubectl get deployments

                                else
                                        echo "Je hebt geen database"
                                fi
                                ;;
                        *)
                                echo "Dit is geen keuze"
                                ;;
                esac
                ;;



        *)
                echo "Dit is geen keuze"
                ;;
esac
