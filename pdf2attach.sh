#!/bin/bash
#script to extract ATT&CK TTP from pdfs

FILE1="$1"
FILE2="${FILE1}.temp"
FILE3="${FILE2}.clean"
FILE4="${FILE1}.txt"
TECHNIQUES="list_techniques.txt"

pdftotext $FILE1 $FILE2

# oneliner
tr '\r\n' ' ' < $FILE2 > $FILE3

#URL remover and paragraph to oneliner
cat $FILE3 | sed -e 's!http[s]\?://\S*!!g' > $FILE2

tr '\012' ' ' < $FILE2 | sed "s#\([\.\?\!]\)#\1\n#g" > $FILE4

mv $FILE2 /root/thesis/WIP/scripts/tmp_trash
mv $FILE3 /root/thesis/WIP/scripts/tmp_trash

OUTPUT="${FILE4}.dataset"

#clean file
> $OUTPUT


IFS=$'\n'       # make newlines the only separator
for x in $(cat ./$TECHNIQUES)
do

#store string
STRING_FOUND=$(grep -w -i "$x" $FILE4)

#save technique and string if not found 
if [[ ! -z $STRING_FOUND ]]; then
echo "$x#$STRING_FOUND" >> $OUTPUT
fi

done
#cleanup
mv $FILE4 /root/thesis/WIP/scripts/tmp_trash
