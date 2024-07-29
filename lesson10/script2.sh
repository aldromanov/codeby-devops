#! /bin/bash

DIR_NAME="myfolder"
PATH_FOLDER=$HOME/$DIR_NAME
SIZE_PATH=${#PATH_FOLDER}+1

if [ ! -d $PATH_FOLDER ]
then echo ">> - Folder '$DIR_NAME' isn't existing"
else echo ">> + Counting files in folder '$DIR_NAME' - $(ls $PATH_FOLDER | wc -l)"
 if [ -f $PATH_FOLDER/myfile2 ]
 then echo ">>   + File 'myfile2' changing access" && chmod -R 644 $PATH_FOLDER/myfile2
 else echo ">>   - File 'myfile2' isn't existing"
 fi
 for entry in $PATH_FOLDER/*
 do FILE_NAME=${entry:$SIZE_PATH}
  if [ ! -s $entry ]
  then echo ">> - File '$FILE_NAME' is empty, deleting it" && rm -r $entry
  else echo ">> + File '$FILE_NAME' isn't empty"
  echo ">>   - In file '$FILE_NAME' deletes all lines except the first line" && echo "$(sed '1! d' "$entry")" > "$entry"
 fi
 done
fi