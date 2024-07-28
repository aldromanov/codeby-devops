#! /bin/bash

DIR_NAME="myfolder"
PATH_FOLDER=$HOME/$DIR_NAME
FORMAT_DATE="$(date +'%H:%M:%S %d/%m/%Y')"

if [ ! -d $PATH_FOLDER ]
then echo ">> + Creating folder '$DIR_NAME'" && mkdir -p $PATH_FOLDER
else echo ">> - Folder '$DIR_NAME' is already exists"
fi

cd $PATH_FOLDER

for i in {1..5}
do if [ ! -f myfile$i ]
 then echo ">> + Creating file 'myfile$i'" && touch myfile$i
 else echo ">> - File 'myfile$i' is existing"
 fi
done

echo ">>   + In file 'myfile1' adding string" && echo -e "Hello\n$FORMAT_DATE" > myfile1
echo ">>   + File 'myfile2' changing access" && chmod 777 myfile2
echo ">>   + In file 'myfile3' adding 20 random chars" && base64 /dev/urandom | head -c 20 > myfile3