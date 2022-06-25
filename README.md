# Cookies

Practice exercise for CPSC 449 Web Back-End Engineering by Prof. Avery at California State University, Fullerton.

The goal of this exercise is to see low-level details of how a [stateless HTTP application][1] can [remember][2] the current state of a user's interactions.


## Cookies from the Terminal

Command lines tools ([HTTPie][1] and [jq][3]) will be used to glue two different public web APIs ([HTTPBin][4] and [JSONPlaceholder][5]) to remember which page a user is currently viewing.


#### Getting Started

+ Install HTTPie and jq

+ Ensure that `http` can be used to retrieve HTTPBin endpoints

  ```
  http httpbin.org/status/418
  http POST httpbin.org/post test=true
  ```

+ HTTPBin provides server-side support for cookies, but does not store them. This means that the `Cookie:` request header is not part of it's response, even though `Set-Cookie:` is allowed in the request

  ```
  http "httpbin.org/cookies"                     # retrieve
  http "httpbin.org/cookies/set?username=foo"    # set cookie
  http "httpbin.org/cookies"                     # retrieve again
  ```

+ Explicitly adding the `Cookie:` header also doesn't persist the value

  ```
  http "httpbin.org/cookies" "Cookie:username=foo"    # set cookie
  http "httpbin.org/cookies"                          # retrieve again
  ```

+ Cookie headers in the request are not required by web browsers. To emulate cookies, HTTPie's [named sessions][6] can be used with the `--session` flag.

  ```
  http "httpbin.org/cookies" --session=./foo.json                     # retrieve
  http "httpbin.org/cookies/set?username=foo" --session=./foo.json    # set cookie
  http "httpbin.org/cookies" --session=./foo.json                     # retrieve again
  ```

+ As per [docs][7], the `domain` field binds cookies to a specified hostname and it's subdomains. If the `domain` field is `null`, the cookie is unbound i.e., it is available to all hosts, including cross-domain redirect chains.

#### Exercise

+ Use HTTPBin to set a cookie named page for user foo to 1
+ Retrieve the page set in the cookie and use it for paginating JSONPlaceholder.
+ Use HTTPBin to set the page for user foo to 2.
+ Retrieve the page set in the cookie and use it for paginating JSONPlaceholder.

  (Do this in a new session file named bar.json.)

+ Use HTTPBin to set a cookie named page for user bar to 3.
+ Retrieve pages for both users to verify that user foo sees page 2 while user bar sees page 3.
+ Use HTTPBin to set the page for user bar to 4.
+ Retrieve pages for both users to verify that foo is still on page 2 while bar is on page 4.


#### Solution

+ Observation: Based on the [cookie storage behavior][8], domain value is set when the `Set-Cookie` header is passed. In this case, it is passed with query string `page=1`

  ```
  http "httpbin.org/cookies/set?page=1" "Cookie:user=foo" --session=./foo.json
  cat foo.json
  ```

  This means that the **domain field is empty** when the below request is sent:

  `http "httpbin.org/cookies" "Cookie:user=foo;page=1" --session=./biz.json`

+ Retrieve page in cookie for pagination in JSONPlaceholder

  ```
  user_foo_page=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
  echo $user_foo_page
  http "jsonplaceholder.typicode.com/posts?_page=$user_foo_page&_limit=25"
  ```

+ Set (update) `page` for user *foo* to 2

  `http "httpbin.org/cookies/set?page=2" --session=./foo.json`

+ Retrieve page set in cookie from JSONPlaceholder

  ```
  user_foo_updated_age=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
  echo $user_foo_updated_age
  http "jsonplaceholder.typicode.com/posts?_page=$user_foo_updated_age&_limit=25"
  ```

+ Set a cookie named page for user bar to 3

  `http "httpbin.org/cookies/set?page=3&user=bar" --session=./bar.json`

+ Retrieve pages for users foo and bar

  ```
  foo_page=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./foo.json)
  bar_page=$(jq --raw-output '.cookies[] | select(.name=="page") | .value' ./bar.json)
  ```

+ Script Usage

  ```
  chmod +x ./cookies.sh
  ./cookies.sh
  ```

---


[1]: https://httpie.io/
[2]: https://httpie.io/docs/cli/sessions
[3]: https://stedolan.github.io/jq/
[4]: https://httpbin.org/
[5]: https://jsonplaceholder.typicode.com/
[6]: https://httpie.io/docs/cli/named-sessions
[7]: https://httpie.io/docs/cli/host-based-cookie-policy
[8]: https://httpie.io/docs/cli/cookie-storage-behavior
