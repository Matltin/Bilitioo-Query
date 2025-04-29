package db

import (
	"database/sql"
	"log"
	"os"
	"testing"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	testDB, err := sql.Open("postgres", "postgresql://root:secret@localhost:5432/test_for_bilitioo_db?sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
