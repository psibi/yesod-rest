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

## GET Request

``` text
curl --header "Accept: application/json" http://localhost:3000/api/v1/user
```

``` json
{
  "name": "Sibi",
  "age": 26
}
```

## POST Request

``` text
curl -i --header "Accept: application/json" -X POST -d '{"ident":"Sibi Prabakaran","password":"strongPassword"}' http://localhost:3000/api/v1/user
```

``` http
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Date: Fri, 09 Sep 2016 17:57:40 GMT
Server: Warp/3.2.8
Content-Type: application/json; charset=utf-8
Set-Cookie: _SESSION=Ch3WRY8GM9nVwwsjYU7SmfHloAneNgflzNuOUyyaXw5aEj5M+Ok/6qrtq5cLT5HR0htufC2ZdE7K0LvWFPoAEt7+lNdgYYnz+WwTnkXIGxCyEQj2LXhvaxdqf5OUGGuRPrvqlWbKBwE=; Path=/; Expires=Fri, 09-Sep-2016 19:57:40 GMT; HttpOnly
Vary: Accept, Accept-Language
```

``` json
{
  "ident": "Sibi Prabakaran",
  "password": "strongPassword"
}
```

Passing the same request again will give an `500` status code because
it will violate the uniqueness constraint of the DB Schema.

```
curl -i --header "Accept: application/json" -X POST -d '{"ident":"Sibi Prabakaran","password":"strongPassword"}' http://localhost:3000/api/v1/user
```

``` http
HTTP/1.1 500 Internal Server Error
Transfer-Encoding: chunked
Date: Fri, 09 Sep 2016 18:14:45 GMT
Server: Warp/3.2.8
Content-Type: application/json; charset=utf-8
Set-Cookie: _SESSION=Eumei1PVc9GOFWVRKw+jzQuk+ijlarUMueuYm5mvN2gnOhAG9VQHvceOdLXVWjFAjDZcJ4rj0cZrPFbcqQIb0R55bhGDtuSJhQlOQoIKPeclfMh6I4kol0Pkv8xcInJQ0s0zH9XTCR8=; Path=/; Expires=Fri, 09-Sep-2016 20:14:45 GMT; HttpOnly
Vary: Accept, Accept-Language
```

``` text
{"error":"SqlError {sqlState = \"23505\", sqlExecStatus = FatalError,
sqlErrorMsg = \"duplicate key value violates unique constraint
\\\"unique_user\\\"\", sqlErrorDetail = \"Key (ident)=(Sibi
Prabakaran) already exists.\", sqlErrorHint =
\"\"}","message":"Internal Server Error"}
```

## PATCH Request

``` shell
curl -i --header "Accept: application/json" -X PATCH http://localhost:3000/api/v1/user/sibi
```

``` http
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Date: Fri, 09 Sep 2016 22:53:06 GMT
Server: Warp/3.2.8
Content-Type: application/json; charset=utf-8
Set-Cookie: _SESSION=Yvx90pnkmvDybys5+2dS4O6wwupCM+k46bWHHxxD29MO7KU9kPPzxP44ZT0pVN4YBwT8LjsLja8eVsg055HXWnnN6ot4/BFwkJcarIQ20COroeoJ+mxzNQ1AL+324n1a/gnCZWCCupI=; Path=/; Expires=Sat, 10-Sep-2016 00:53:06 GMT; HttpOnly
Vary: Accept, Accept-Language
```

``` json
{
  "id": 1,
  "ident": "sibi",
  "password": null
}
```

Also demonstrating the custom error handling in PATCH method:

``` shell
curl -i --header "Accept: application/json" --request PATCH http://localhost:3000/api/v1/user/sibi_invalid_request
```

``` http
HTTP/1.1 400 Bad Request
Transfer-Encoding: chunked
Date: Fri, 09 Sep 2016 22:57:28 GMT
Server: Warp/3.2.8
Content-Type: application/json; charset=utf-8
Set-Cookie: _SESSION=6JraQjDLpGRyZ0/f14zVMvcHQBGY+pIuBVriVal0uMRsadj6ZJA5xirafSAham1q9w2Us0h7AsUfE/Me/aIkZkx3C4jnHXxMR9Wc+zTXCQWPAiSTH3PtZF3dvDkedfSB+aSc+nvJGCU=; Path=/; Expires=Sat, 10-Sep-2016 00:57:28 GMT; HttpOnly
Vary: Accept, Accept-Language
```

``` json
{
  "errors": [
    "User id is invalid"
  ],
  "message": "Invalid Arguments"
}
```


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
