package packages

import (
	"os"
	"testing"
)

func TestNewDBS(t *testing.T) {
	//лог в файловый дескриптор
	fout, err := os.OpenFile("/tmp/logout", os.O_CREATE|os.O_WRONLY, os.ModePerm)
	if err != nil {
		t.Fatal(err)
	}
	dbs := NewDBS(fout)
	dbs.l.Printf("[file handler] example test message from dbs instance %v\n", dbs)

	//лог на os.stdout
	dbs2 := NewDBS(os.Stdout)
	dbs2.l.Printf("[os.stdout] example test message from dbs instance %v\n", dbs2)
}

func TestDBS_Open(t *testing.T) {
	dbs := NewDBS(os.Stdout)
	dbs.Open(DatabaseOptions{
		User:         "root",
		Password:     "root",
		Host:         "127.0.0.1",
		Port:         "3306",
		DatabaseName: "spouk",
		ListTables:   nil,
	})
}
