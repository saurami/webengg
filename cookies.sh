http "httpbin.org/cookies/set?page=1" "Cookie:user=foo" --session=./foo.json > /dev/null
user_foo_page=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
http "jsonplaceholder.typicode.com/posts?_page=$user_foo_page&_limit=25" > /dev/null


http "httpbin.org/cookies/set?page=2" --session=./foo.json > /dev/null
user_foo_updated_age=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
http "jsonplaceholder.typicode.com/posts?_page=$user_foo_updated_age&_limit=25" > /dev/null


http "httpbin.org/cookies/set?page=3&user=bar" --session=./bar.json > /dev/null
foo_page_updated=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
bar_page=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./bar.json)

foobar1(){
	if [ "$foo_page_updated" = "$bar_page" ]; then
		echo "[FAILED] Values should not be the same ..."
	else
		echo "[PASSED] Values of updated foo and initial bar are different"
	fi
}

http "httpbin.org/cookies/set?page=4" --session=./bar.json > /dev/null
bar_page_updated=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./bar.json)

foobar2(){
	if [ "$foo_page_updated" = "$bar_page_updated" ]; then
		echo "[FAILED] Values should not be the same ..."
	else
		echo "[PASSED] Values of updated foo and updated bar are different"
	fi
}

echo "Testing updated foo and initial bar ..."
foobar1
echo "Test 1 complete!"
echo "----"
echo "Testing updated foo and updated bar ..."
foobar2
echo "Test 2 complete!"
