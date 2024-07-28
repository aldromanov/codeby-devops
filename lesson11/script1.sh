#! /bin/bash

####################################################################
#                                                                  #
#  script1.sh                                                      #
# • Создает папку myfolder в домашней папке текущего пользователя  #
# • Создает 5 файлов в папке:                                      #
#  1 - имеет две строки: 1) приветствие, 2) текущее время и дата   #
#  2 - пустой файл с правами 777                                   #
#  3 - одна строка длиной в 20 случайных символов                  #
#  4-5 пустые файлы                                                #
#                                                                  #
####################################################################

#Константы
PATH_FOLDER=$HOME/myfolder
FORMAT_DATE="$(date +'%H:%M:%S %d/%m/%Y')"
PATH_FILE1=$PATH_FOLDER/myfile1
PATH_FILE2=$PATH_FOLDER/myfile2
PATH_FILE3=$PATH_FOLDER/myfile3
PATH_FILE4=$PATH_FOLDER/myfile4
PATH_FILE5=$PATH_FOLDER/myfile5

# Проверка, существует ли папка myfolder в домашней папке пользователя
if [ ! -d $PATH_FOLDER ]
# Если папки myfolder не существует, то создает ее
then mkdir -p $PATH_FOLDER
fi

# Создаем myfile1 в папке myfolder и добавляем две строки
echo -e "Hello\n$FORMAT_DATE" > $PATH_FILE1
# Создаем myfile2 в папке myfolder с правами 777
touch $PATH_FILE2 && chmod 777 $PATH_FILE2
# Создаем myfile3 в папке myfolder и добавляем 20 случайных символов
base64 /dev/urandom | head -c 20 > $PATH_FILE3
# Создаем myfile4 и myfile5 в папке myfolder
touch $PATH_FILE4 $PATH_FILE5