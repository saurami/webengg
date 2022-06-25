course="${1}"
tmp_file="catalog_search_data.html"
http GET https://catalog.fullerton.edu/search_advanced.php \
	cur_cat_oid==75 search_database==Search search_db==Search cpage==1 ecpage==1 ppage==1 spage==1 \
	tpage==1 location==33 filter\[keyword\]=="CPSC $course" filter\[exact_match\]==1 > $tmp_file
cat $tmp_file | grep "Best Match:"
rm $tmp_file
