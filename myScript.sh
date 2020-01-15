#!/bin/bash
#The purpose of our script is to automate pulling headlines from the Boston Globe using the command line. Without arguments, it goes to the home page. With certain arguments, you can pull headlines from specific pages. 

#getopts is the tool we used to pass in our arguments. The letters specify which arguments will be accepted. Opt is an argument to getopts that holds the option / argument that will be processed next. We did a do while loop to go through the possible commands we could have been passed. Depending on the command, we updated the end of the url we wanted to search for. 

#grep is a command that helps act as a filter. It can look for a pattern of characters and show the matching content. We searched for anything with the class "headline" because we were most interested in displaying headlines. 

#cut is a command that allows you to cut out parts of lines and, depending on your specifications, print out parts of those lines. We first cut the characters 350-600 because they were HTML style that was not the data we wanted to use. We did this using -c which removes those lines. We then used cut again to split the line specifing a delimeter (a point at which to segment the lines), being the "<" symbol because it broke up what we wanted to get easily. We chose a section of text by specifying which field we wanted with the -f2 command (2 meaning second field). We used cut one more time to cut by a different delimeter and further trim our answer down to human-readable information. 

#We used sort -u to first sort the output of headlines, and then -u part to remove any subsequent ones that were not unique. We saved this in another file. 

#We took the output of that file and looped over it in a for loop to check if it had the output we wanted (capital letters beginning each line), and if the line fit our criteria, we printed it out. Before printing out all the headlines, we used printf in order to print out "Today's Boston Globe Headlines" with a couple of new lines.

while getopts ":splmh" opt; do
  case ${opt} in
    s ) 
	pagelocation="sports/"
      ;;
    p )
	pagelocation="nation/politics/"
      ;;
    l ) 
	pagelocation="lifestyle/"
      ;;
    m ) 
	pagelocation="marijuana/"
      ;;
    h ) 
	echo " Type in the chosen page via command to navigate to sports [-s], politics [-p], lifestyle [-l] or marijuana[-m] news."
      ;;

    \? ) echo "Usage: cmd [-s] for sports, [-p] for politics, [-l] for lifestyle, [-m] for marajuana, [-h] for help"
      ;;
  esac
done 

url="https://www.bostonglobe.com/${pagelocation}"
echo $url
curl $url | grep -e 'class="headline'  | cut -c 350-600 | cut -d "<" -f2 | cut -d ">" -f2 >> tmp_file

sort -u tmp_file >> tmp_file2
file=tmp_file2

printf "Today's Boston Globe Headlines:\n\n"

cat tmp_file2 | while read line
do
	if [[ ${line:0:1} =~ [A-Z] ]]
	then
	echo $line
	fi
done

rm tmp_file
rm tmp_file2 
