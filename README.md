# Catalog

Practice exercise for CPSC 449 Web Back-End Engineering by Prof. Avery at California State University, Fullerton

## Getting Started

+ [Backend Developer Roadmap][1]

+ [Hacker News][2]


## HTTP from the Terminal

[HTTPie][5] is a command-line HTTP client that is primarily used for accessing web APIs. This is an alternative to using a web browser, which is a graphical HTTP client. The former has advantages because commands are precise and repeatable.

#### Getting Started

+ Install HTTPie

+ Ensure that CSUF's [course catalog][6] webpage can be retrieved using HTTPie

  `http GET https://catalog.fullerton.edu/`

#### Exercise

+ Using the browser's [Page Inspector][7] and / or [Network Monitor][8] find "Catalog Search"

+ Search for "CPSC 449" and submit the form

+ Pipe the above output to `grep` to search for "Best Match:". (**Note**: This should print the line containing the title of the course.)

+ Combine the previous two steps into a shell script with a [positional parameter][9] that can be used to search another course, e.g.

  `./catalog.sh 349`

#### Solution

+ Enter keyword "CPSC 449" in the search box and open [Network Monitor][8]

+ Click the "search" icon and view the request to domain [catalog.fullerton.edu][6]. For "CPSC 449" its:

  ```
  GET https://catalog.fullerton.edu/search_advanced.php?cur_cat_oid=75&search_database=Search&search_db=Search&cpage=1&ecpage=1&ppage=1&spage=1&tpage=1&location=33&filter[keyword]=CPSC 449&filter[exact_match]=1
  ```

+ Additionally, [translate][10] the GET request to an equivalent `curl`:

  ```
  curl "https://catalog.fullerton.edu/search_advanced.php?\
  cur_cat_oid=75&\search_database=Search&search_db=Search&\
  cpage=1&ecpage=1&ppage=1&spage=1&tpage=1&\
  location=33&filter%5Bkeyword%5D=CPSC%20449&filter%5Bexact_match%5D=1" \
    | grep "Best Match:"
  ```

+ `http` equivalent of the above `curl`:

  ```
  http GET https://catalog.fullerton.edu/search_advanced.php \
    cur_cat_oid==75 search_database==Search search_db==Search \
    cpage==1 ecpage==1 ppage==1 spage==1 tpage==1 \
    location==33 filter\[keyword\]=="CPSC $course" filter\[exact_match\]==1 \
      | grep "Best Match:"
  ```

+ Make the script executable:

  `chmod +x ./catalog.sh`

+ Usage:

  `./catalog.sh CPSC_IDENTIFIER`


## Additional Reading

+ [Web Architecture 101][3] from the Storyblocks Product & Engineering blog

+ [Introduction to architecting systems for scale][4] by Will Larson


---

**Miscellaneous**

+ [Missing Semester][11]

[1]: https://roadmap.sh/backend
[2]: https://news.ycombinator.com/item?id=18961793
[3]: https://medium.com/storyblocks-engineering/web-architecture-101-a3224e126947
[4]: https://lethain.com/introduction-to-architecting-systems-for-scale/
[5]: https://httpie.io/cli
[6]: https://catalog.fullerton.edu/
[7]: https://firefox-source-docs.mozilla.org/devtools-user/page_inspector/index.html
[8]: https://firefox-source-docs.mozilla.org/devtools-user/network_monitor/index.html
[9]: https://bash.cyberciti.biz/guide/$1
[10]: https://en.wikipedia.org/wiki/Percent-encoding
[11]: https://missing.csail.mit.edu
