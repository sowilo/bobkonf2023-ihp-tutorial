ifneq ($(wildcard IHP/.*),)
IHP = IHP/lib/IHP
else
ifneq ($(wildcard build/ihp-lib),)
IHP = build/ihp-lib
else
ifneq ($(shell which RunDevServer),)
IHP = $(shell dirname $$(which RunDevServer))/../lib/IHP
else
IHP = $(error IHP not found! Run the following command to fix this:    nix-shell --run 'make .envrc'    )
endif
endif
endif

CSS_FILES += ${IHP}/static/vendor/bootstrap.min.css
CSS_FILES += ${IHP}/static/vendor/flatpickr.min.css
CSS_FILES += static/app.css

JS_FILES += ${IHP}/static/vendor/jquery-3.6.0.slim.min.js
JS_FILES += ${IHP}/static/vendor/timeago.js
JS_FILES += ${IHP}/static/vendor/popper.min.js
JS_FILES += ${IHP}/static/vendor/bootstrap.min.js
JS_FILES += ${IHP}/static/vendor/flatpickr.js
JS_FILES += ${IHP}/static/helpers.js
JS_FILES += ${IHP}/static/vendor/morphdom-umd.min.js
JS_FILES += ${IHP}/static/vendor/turbolinks.js
JS_FILES += ${IHP}/static/vendor/turbolinksInstantClick.js
JS_FILES += ${IHP}/static/vendor/turbolinksMorphdom.js

include ${IHP}/Makefile.dist

## Replacement for target 'db'
## i.e., restore the database based on the current content of:
## - Application/Schema.sql
## - Application/Fixtures.sql
##
## In addition to what 'db' does, this also:
## - recreates the schema_migrations table
## - regenerates the Generated.Types module
#
resetdb: Application/Schema.sql Application/Fixtures.sql
	echo "drop schema public cascade; create schema public;" | psql -h $$PWD/build/db -d app
	psql -h $$PWD/build/db -d app < "${IHP_LIB}/IHPSchema.sql"
	psql -h $$PWD/build/db -d app < Application/Schema.sql
	./Application/Script/InitDb.hs
	psql -h $$PWD/build/db -d app < Application/Fixtures.sql
	$(MAKE) -B build/Generated/Types.hs

.PHONY: revertdb

## Commit the current database setup
##
## - schema, user data and migrations are commited
## - the data currently stored is dumped beforehand
## - the current staging area is saved and restored if necessary
## - a commit message can be passed through the environment variable $MSG
#
# files related to the current db state
DBFILES = $(wildcard Application/Migration/*.sql) Application/Schema.sql Application/Fixtures.sql
# db related files as they might appear in staged files list
GIT_PREFIX = $(patsubst $(shell git rev-parse --show-toplevel)/%,%/,$(shell pwd))
GIT_DBFILES = $(if $(GIT_PREFIX), $(patsubst %,$(GIT_PREFIX)%, $(DBFILES)),$(DBFILES))
# get currently stages files (excl. db related files)
STAGED = $(filter-out $(GIT_DBFILES),$(shell git diff --name-only --cached))
# commit message
ifdef MSG
COMMIT_MSG = "$(MSG)"
endif
COMMIT_MSG ?= "update database"

.PHONY: commitdb
commitdb: Application/Schema.sql
# unstage all files
ifneq ($(STAGED),)
	git reset
endif
# dump current state into Fixtures.sql
	$(MAKE) dumpdb
# stage and commit db related files
	git add $(DBFILES)
	git diff --quiet --exit-code --cached && echo 'nothing to commit' ||  git commit -m $(COMMIT_MSG)
# restore staged area
ifneq ($(STAGED),)
	git add $(patsubst $(GIT_PREFIX)%,%,$(STAGED))
endif
