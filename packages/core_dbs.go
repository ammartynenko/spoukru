package packages

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"io"
	"log"
)

//типы используемые в этом пакете
type (
	DBS struct {
		l   *log.Logger
		d   *sql.DB
		dsn *DatabaseOptions
	}
	DatabaseOptions struct {
		User, Password, Host, Port, DatabaseName string
		ListTables                               []interface{}
	}
)

//константные переменные
const (
	prefixDBS = "[dbs] "
)

//переменные
var (
	bitMask                = log.Lshortfile | log.LstdFlags
	msgCorrectOpenDatabase = "database success %s open"
)

//создание нового инстанса
func NewDBS(logger io.Writer) DBS {
	ins := DBS{
		l: log.New(logger, prefixDBS, bitMask),
	}
	return ins
}

//создание хэндлера для работы с базой данных
func (d DBS) Open(dsn DatabaseOptions) {
	if d.dsn == nil {
		d.dsn = &dsn
	}
	if ndb, err := sql.Open("mysql", d.makeDSN(dsn)); err != nil {
		d.l.Fatal(err)
	} else {
		d.d = ndb
		d.l.Printf(msgCorrectOpenDatabase, d.dsn.DatabaseName)
	}
}

//функция помощь для генерации корректного dsn для создания подключения к базе данных
func (d DBS) makeDSN(dsn DatabaseOptions) string {
	d.dsn = &dsn
	return fmt.Sprintf("%s:%s@(%s:%s)/%s?charset=utf8&parseTime=True&loc=Local",
		d.dsn.User, d.dsn.Password, d.dsn.Host, d.dsn.Port, d.dsn.DatabaseName)
}
