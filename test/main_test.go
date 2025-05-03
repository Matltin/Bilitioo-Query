package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq" 
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	testDB, err := sql.Open("postgres", "postgresql://root:secret@localhost:5432/bilitioo?sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
