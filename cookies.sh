#!/usr/bin/zsh

http "httpbin.org/cookies/set?page=1" "Cookie:user=foo" --session=./foo.json > /dev/null
foo_page=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
http "jsonplaceholder.typicode.com/posts?_page=$foo_page&_limit=25" > /dev/null

http "httpbin.org/cookies/set?page=2" --session=./foo.json > /dev/null
foo_page_updated=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
http "jsonplaceholder.typicode.com/posts?_page=$foo_page_updated&_limit=25" > /dev/null

http "httpbin.org/cookies/set?page=3&user=bar" --session=./bar.json > /dev/null
bar_page=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./bar.json)

foobar1(){
	if [[ "$foo_page_updated" == 2 && "$bar_page" == 3 ]]; then
		echo "[PASSED] Correct values of updated foo and initial bar"
	else
		echo "[FAILED] Incorrect values $foo_page_updated and $bar_page ..."
	fi
}

http "httpbin.org/cookies/set?page=4" --session=./bar.json > /dev/null
bar_page_updated=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./bar.json)

foobar2(){
	if [[ "$foo_page_updated" == 2 && "$bar_page_updated" == 4 ]]; then
		echo "[PASSED] Correct values of updated foo and updated bar"
	else
		echo "[FAILED] Incorrect values $foo_page_updated and $bar_page_updated ..."
	fi
}

echo "Testing updated foo and initial bar ..."
foobar1
echo "Test 1 complete!"
echo "----"
echo "Testing updated foo and updated bar ..."
foobar2
echo "Test 2 complete!"
