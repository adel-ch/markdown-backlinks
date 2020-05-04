#!/bin/bash

#FIX backlinking backlinks in get_files_that_reference

# test if a folder path has been provided
if [ ! -d "$1" ]
  then
    echo "Directory not found"
    exit 1;
fi
folder_path=$1


get_md_files_in_folder()
{
   # create a string with all markdown filenames in folder and return it
   for markdown_file in "$folder_path"/*.md
   do
      markdownfiles+="`echo $markdown_file | grep -oE [0-9]{14}`;"
   done
   echo $markdownfiles
}

get_files_that_reference()
{
   # find files that reference current note and remove extension to keep only the ID. This is to be corrected
   #files_that_reference_array=($(grep -ls $1 $folder_path/* | grep -oE [0-9]{14}))
   for markdown_file in "$folder_path"/*.md
   do
   markdown_file_trimmed=`echo $markdown_file | grep -oE [0-9]{14}`
     if $(sed "/Backlinks/q" $folder_path/$markdown_file_trimmed.md | grep -nq $1 ); then
        files_that_reference_array=( "${files_that_reference_array[@]}" "$markdown_file_trimmed" )
     fi
   done

}

add_backlinks_to_file()
{
   # Check if there actually are backlinks to be inserted
   if [ ${#files_that_reference_array[@]} -gt 0 ]; then
      # create text block to be inserted with backlinks
      text_block="\n\n# Backlinks"
      for backlink in "${files_that_reference_array[@]}"
      do
         text_block+="\n[[$backlink]]"
      done
      echo ----- ADDING BACKLINKS TO $1.md -----
      # Write text block
      echo -e $text_block >> $folder_path/$1.md
      unset files_that_reference_array
   fi
}

delete_old_backlinks()
{
   echo ----- DELETING OLD BACKLINKS IN $1.md -----
   # Delete everything after backlinks heading
   sed -i '/^# Backlinks$/,$d' $folder_path/$1.md
   # Delete trailing white lines
   sed  -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' $folder_path/$1.md
}



####### MAIN SCRIPT ######
echo folder path : $folder_path
# Get all md files in folder_path
md_files_in_folder=$(get_md_files_in_folder $folder_path)
echo files list : $md_files_in_folder

# Split md files list into an array
IFS=';' read -r -a arr <<< "$md_files_in_folder"

# Delete all lines after Backlinks heading
for md_file in "${arr[@]}"
do
   delete_old_backlinks $md_file
done 

# Insert backlinks
for md_file in "${arr[@]}"
do
   # array to hold all filenames that reference current note
   declare -a files_that_reference_array
   # fill the array with filenames that reference current note
   get_files_that_reference $md_file
   echo files that reference $md_file are ${files_that_reference_array[@]}
   # Add all backlinks to current file at the end
   add_backlinks_to_file  $md_file

done 
