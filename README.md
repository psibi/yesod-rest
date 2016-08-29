yesod-rest
-----------

Status: Work in progress

A Yesod scaffolding site with Postgres backend. It provides a JSON API
backend as a
[separate subsite](http://www.yesodweb.com/book/creating-a-subsite). The
primary purpose of this repository is to use Yesod as a API server
backend and do the frontend development using a tool like React or
Angular. So, I will most likely remove `yesod-form` and other related
code which is not required. Also, If I'm happy with this, I will try
to integrate this as a stack template.

# Setup (on an Ubuntu system)

1. Install [Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/).
2. sudo apt-get install libpq-dev
3. cd yesod-rest
4. cd static && npm install
5. npm run webpack
6. stack build

# Demo:

`curl --header "Accept: text/html" http://localhost:3000/api/v1

no match found for accept headers`


`curl --header "Accept: application/json" http://localhost:3000/api/v1

{"age":26,"name":"Sibi"}`


# FAQ
