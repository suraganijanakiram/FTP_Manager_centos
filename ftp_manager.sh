#!/bin/bash
#used to manage FTp in centos and redhat systems
#email or comment suggestions and feedback to suraganijanakiram@gmail.com
clear

check_conf()

{

if [ -f "/etc/vsftpd/vsftpd.conf" ];

then

        true

else

        echo -e "\n\t \e[1;31m Install the package first. vsftpd conf file does not exists! \e[0m \n"

        break

fi

}

install()

{

if [ -f "/etc/vsftpd/vsftpd.conf" ];

then

        echo -e "\n\t\e[1;32mAlready installed\e[0m"

else

        yum clean all > /dev/null

        yum install vsftpd ftp -y > /dev/null

        sed -i 's/^anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf

        sed -i '/chroot_list_enable/s/^#//g' /etc/vsftpd/vsftpd.conf

        sed -i '/chroot_list_file/s/^#//g' /etc/vsftpd/vsftpd.conf

                if [ -f "/etc/vsftpd/chroot_list" ];

                then

                        true

                else

                        touch /etc/vsftpd/chroot_list

                fi
        service vsftpd restart
echo -e "\n\n\t \e[1;32m Installation of packages and configuration completed \e[0m \n"

fi

}


check_user()

{

awk -F ":" {'print $1'} /etc/passwd | egrep "^$u1$" > /dev/null

        if [ $? -eq 0 ]; then

                cat /etc/vsftpd/chroot_list | egrep "^$u1$" > /dev/null

                if [ $? -eq 0 ]; then

                        echo -e "\n\t\e[1;32m$u1\e[0m \e[1;31muser Already chrooted \e[0m "

                else

                        echo $u1 >> /etc/vsftpd/chroot_list

                        echo -e "\n\t\e[1;32m$u1 chrooted successfully \e[0m"

                fi

        else

                echo -e "\n\t\e[1;32m$u1\e[0m \e[1;31m user does not exist! \e[0m \n"

        fi

}

chrooting_a()

{

while :

do

echo -n -e "\n\tDo you want to chroot another ftp user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read oo

case $oo in

        [yY]|[yY][eE][sS])

                echo -n -e "\nPlease enter the another username to chroot: "

                read u1

                check_user

        ;;

        [nN]|[nN][oO])

                break

        ;;

        *)

                echo -e "\n\t \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}

chrooting()

{

while :

do

echo -n -e "\n\tDo you want to chroot \e[1;32m$u1\e[0m user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read ooo

case $ooo in

        [yY]|[yY][eE][sS])

                check_user

                break

        ;;

        [nN]|[nN][oO])

                break

        ;;

        *)

                echo -e "\n \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}

up_adding()

{

#                        echo -n -e "Please enter the password for \e[1;32m$u1\e[0m : "

#                        read p1

                        useradd -m -s /sbin/nologin $u1

p1=$u1@$(id $u1 | awk -F "=" {'print $2'} | awk -F "(" {'print $1'})*

                        echo -e "$p1\n$p1\n\n" | passwd $u1
                        echo -e "\n\tThe password for user \e[1;32m$u1\e[0m is \e[1;32m$p1\e[0m"
                        chrooting

}

addinguser_a()

{

while :

do

echo -n -e "\n\tDo you want to add another ftp user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read oo

case $oo in

        [yY]|[yY][eE][sS])

                echo -n -e "\nPlease enter the another username for ftpuser: "

                read u1

                awk -F ":" {'print $1'} /etc/passwd | egrep "^$u1$" > /dev/null

                if [ $? -eq 0 ]; then

                        echo -e "\n\t \e[1;32m$u1\e[0m \e[1;31m user Already exists! \e[0m "

                else

                        up_adding

                fi


        ;;

        [nN]|[nN][oO])

                break

        ;;

        *)

                echo -e "\n\t \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}

addinguser()

{

while :

do

echo -n -e "\n\tAdding the ftp user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read o

case $o in

  [yY]|[yY][eE][sS])

        echo -n -e "\nPlease enter the username for ftpuser: "

        read u1

        awk -F ":" {'print $1'} /etc/passwd | egrep "^$u1$" > /dev/null

        if [ $? -eq 0 ]; then

                echo -e "\n\t \e[1;32m$u1\e[0m \e[1;31m user Already exists! \e[0m "

        else

                up_adding

        fi

        addinguser_a

        break

        ;;

 [nN]|[nN][oO])

        echo -e "\n"

        break

        ;;

 *)

        echo -e "\n\t \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}


rc_check_user()

{

awk -F ":" {'print $1'} /etc/passwd | egrep "^$u1$" > /dev/null

        if [ $? -eq 0 ]; then

                cat /etc/vsftpd/chroot_list | egrep "^$u1$" > /dev/null

                if [ $? -eq 0 ]; then

                        sed -i 's#^'$u1'$##' /etc/vsftpd/chroot_list && sed -i '/^$/d' /etc/vsftpd/chroot_list

                        echo -e "\n\t\e[1;32m$u1 un chrooted successfully \e[0m"

                else

                        echo -e "\n\t\e[1;32m$u1 is already un chrooted \e[0m"

                fi

        else

                echo -e "\n\t\e[1;32m$u1\e[0m \e[1;31m user does not exist! \e[0m \n"

        fi

}

removechroot_a()

{

while :

do

echo -n -e "\n\tDo you want to removing chroot for another ftp user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read oo

case $oo in

        [yY]|[yY][eE][sS])

                echo -n -e "\nPlease enter the another username to remove chroot: "

                read u1

                rc_check_user

        ;;

        [nN]|[nN][oO])

                break

        ;;

        *)

                echo -e "\n\t \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}

removechroot()

{

while :

do

echo -n -e "\n\tDo you want to removing chroot for ftp user: \e[1;32m$u1\e[0m user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read ooo

case $ooo in

        [yY]|[yY][eE][sS])

               rc_check_user

                break

        ;;

        [nN]|[nN][oO])

                break

        ;;

        *)

                echo -e "\n \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}


du_check_user()

{

awk -F ":" {'print $1'} /etc/passwd | egrep "^$u1$" > /dev/null

        if [ $? -eq 0 ]; then

                        while :

                        do

                        echo -e "\n\t  1\e[1;32m : \e[0mTo remove ftp user along with home directory \n\n\t  2\e[1;32m : \e[0mTo remove only ftp user \n"

                        read -p "enter the option number : " oo

                        case $oo in

                                1)

                                   /usr/sbin/userdel -rf $u1

                                        break

                                ;;

                                2)

                                   /usr/sbin/userdel $u1

                                        break

                                ;;

                                *)

                                        echo -e "\n\t \e[1;31m Bad argument! \e[0m "

                                ;;

                        esac

                        done

                        echo -e "\n\t\e[1;32m$u1 removed successfully \e[0m"

                else

                echo -e "\n\t\e[1;32m$u1\e[0m \e[1;31m user does not exist! \e[0m \n"

        fi

}

deleteuser_a()

{

while :

do

echo -n -e "\n\tDo you want to remove another ftp user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read oo

case $oo in

        [yY]|[yY][eE][sS])

                echo -n -e "\nPlease enter the another username to delete: "

                read u1

                du_check_user

        ;;

        [nN]|[nN][oO])

                break

        ;;

        *)

                echo -e "\n\t \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}

deleteuser()

{

while :

do

echo -n -e "\n\tDo you want to remove ftp \e[1;32m$u1\e[0m user:[\e[1;32mYes\e[0m/\e[1;31mNo\e[0m] "

read ooo

case $ooo in

        [yY]|[yY][eE][sS])

               du_check_user

                break

        ;;

        [nN]|[nN][oO])

                break

        ;;

        *)

                echo -e "\n \e[1;31m Bad argument! \e[0m "

        ;;

esac

done

}


while :

do

echo -e "\n \e[1;32m choose any one option for ftp:- \e[0m \n\n  1\e[1;32m : \e[0mTo install package and configure \n\n  2\e[1;32m : \e[0mTo add user \n\n  3\e[1;32m : \e[0mTo chroot(Restrict ftp user to his home directory) existing user \n\n  4\e[1;32m : \e[0mTo remove chroot(Restrict ftp user to his home directory) for user \n\n  5\e[1;32m : \e[0mTo delete user \n\n  6\e[1;32m : \e[0mExit"


read -p "enter the option number : " OPT


case $OPT in

  1)

        install

        ;;

  2)

        check_conf

        addinguser


        ;;

  3)

        check_conf

        echo -n -e "\nPlease enter the username to chroot: "

        read u1

        chrooting

        chrooting_a

        ;;

  4)

        check_conf

        echo -n -e "\nPlease enter the username to un chroot: "

        read u1

        removechroot

        removechroot_a

        ;;

  5)

        check_conf

        echo -n -e "\nPlease enter the username to delete ftp user: "

        read u1

        deleteuser

        deleteuser_a

        ;;

  6)

        echo -e "\n\t \e[1;31m Bye! \e[0m \n"

        exit 0

        ;;

  *)

        clear

        echo -e "\n \e[1;31m Bad argument! \e[0m \n"

        ;;

esac

done
