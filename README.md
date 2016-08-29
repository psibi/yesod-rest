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

# Features

1. Provides an API server.
2. Boilerplate for writing frontend code using React Javascript
   ecosystem is provided. (can be easily adapted to other tools like
   Angular, etc.)

# Setup (on an Ubuntu system) and Execution steps

1. Install [Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/).
2. sudo apt-get install libpq-dev postgresql postgresql-contrib
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

1. I see this error on `stack exec yesod-rest`:

``` text
yesod-rest: libpq: failed (could not connect to server: Connection refused
        Is the server running on host "localhost" (127.0.0.1) and accepting
        TCP/IP connections on port 5432?
)
```

You most likely haven't installed the postgres server. For Ubuntu systems, it can be done by:

`sudo apt-get install postgresql postgresql-contrib`

2. I see this error on `stack exec yesod-rest`:

``` text
yesod-rest: libpq: failed (FATAL:  password authentication failed for user "postgres"
FATAL:  password authentication failed for user "postgres"
)
```

[See this.](http://stackoverflow.com/a/7696398/1651941)

3. I see this error on `stack exec yesod-rest`:

``` text
yesod-rest: libpq: failed (FATAL:  database "test" does not exist)
```

Create a database named `test` on your postgres server.





