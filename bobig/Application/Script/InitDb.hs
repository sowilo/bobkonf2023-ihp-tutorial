#!/usr/bin/env run-script
module Application.Script.InitDb where

import Application.Script.Prelude
import IHP.SchemaMigration (createSchemaMigrationsTable)

run :: Script
run = createSchemaMigrationsTable
