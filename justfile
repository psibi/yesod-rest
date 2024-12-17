# List all recipes
default:
	just --list --unsorted

# Build
build:
	stack build --fast

# Run postgres via docker
postgres:
    docker run --name yesod-rest --net=host --rm -it -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:15.3-alpine -c log_statement=all

# psql to docker
psql:
    psql -U postgres -h localhost

# Shutdown postgres
postgres-down:
    docker container stop yesod-rest

# Serve
serve:
	stack run

# Hurl tests
hurl:
	hurl --test rest.hurl
