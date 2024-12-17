yesod-rest
-----------

A Yesod scaffolding site with Postgres backend. It provides a JSON API
backend as a
[separate subsite](http://www.yesodweb.com/book/creating-a-subsite). The
primary purpose of this repository is to use Yesod as a API server
backend and do the frontend development using a tool like React or
Angular.  The current code includes a basic hello world using
[React](https://facebook.github.io/react/) and
[Babel](https://babeljs.io/) which is bundled finally by
[webpack](https://webpack.github.io/) and added in the handler
`getHomeR` in a type safe manner.

# Features

1. Provides an API server.
2. Boilerplate for writing frontend code using React Javascript
   ecosystem is provided. (can be easily adapted to other tools like
   Angular, etc.)
3. Brings all the advantage of Yesod - type safe urls, simple DSL for
   routes etc.

# Setup and Execution steps

1. Install [Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/).
2. sudo apt-get install libpq-dev postgresql postgresql-contrib  (For Debian based systems)
3. cd yesod-rest
4. stack build yesod-bin cabal-install --install-ghc
5. cd static && npm install
6. npm run webpack
7. stack build
8. stack exec -- yesod devel (Runs development server)
9. (Or) stack exec yesod-rest

# Adding a API Route

Add the route to `config/apiRoutes` file and define your corresponding
handler function in `API.hs`.

# Demo:

You can see the [rest.hurl](./rest.hurl)

# FAQ

* I see this error on `stack exec yesod-rest`:

``` text
yesod-rest: libpq: failed (could not connect to server: Connection refused
        Is the server running on host "localhost" (127.0.0.1) and accepting
        TCP/IP connections on port 5432?)
```

You most likely haven't installed the postgres server. For Ubuntu systems, it can be done by:

`sudo apt-get install postgresql postgresql-contrib`

* I see this error on `stack exec yesod-rest`:

``` text
yesod-rest: libpq: failed (FATAL:  password authentication failed for user "postgres"
FATAL:  password authentication failed for user "postgres")
```

[See this.](http://stackoverflow.com/a/7696398/1651941)

* I see this error on `stack exec yesod-rest`:

``` text
yesod-rest: libpq: failed (FATAL:  database "test" does not exist)
```

Create a database named `test` on your postgres server.

* The `webpack` program is automatically getting closed.

Try running this command:

``` shell
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```
