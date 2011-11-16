#!/bin/sh

orgname='myorg'
orgsubnet='192.168'
accesslog='/var/log/httpd/access_log'
contentdbs='/path/to/contentdm/contentdbs/'
start=$(head -n1 ${accesslog} | awk '{print $4,$5 }')
echo $start
echo
echo "collection    |    ${orgname} traffic    |      non-${orgname} traffic    |  not bot total     |     bot     |    total "

for l in $(ls ${contentdbs} | grep -v 'lost+found') 
do  
	# map collection name/foldername exceptions
	if [ "$l" = "yearbook" ]; then
		l="yb"
	fi
	total=$(grep  $l ${accesslog} | wc -l)  
	bot=$(grep  $l ${accesslog} | grep -i 'bot' | wc -l)  
	notbot=$(grep  $l ${accesslog} | grep -v -i 'bot' | wc -l) 
	org=$(grep  $l ${accesslog} | grep -i -v 'bot' | grep -e "^${orgsubnet}" | wc -l) 
	nonorg=$(grep  $l ${accesslog} | grep -i -v 'bot' | grep -v -e "^${orgsubnet}" | wc -l)  
 	
	echo "$l   |    $org   |     $nonorg    |    $notbot   |    $bot    |    $total" 
done
echo
end=$(tail -n1 ${accesslog} | awk '{print $4,$5 }')
echo $end
