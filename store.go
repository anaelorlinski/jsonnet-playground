package main

import (
	"database/sql"
	"errors"
	"sync"

	_ "github.com/go-sql-driver/mysql"
)

var (
	DatastoreNoSuchID = errors.New("The ID you request to lookup doesn't exist in our backend store")
)

type PersistJsonnet interface {
	Get(id string) (string, error)
	Store(id string, code string) error
}

// InMemory is for testing or a quick deploy
type InMemory struct {
	sync.RWMutex
	store map[string]string
}

func (i InMemory) Get(id string) (string, error) {
	i.RLock()
	defer i.RUnlock()
	val, ok := i.store[id]
	if ok {
		return val, nil
	}
	return val, DatastoreNoSuchID
}

func (i InMemory) Store(id string, code string) error {
	i.Lock()
	i.store[id] = code
	i.Unlock()
	return nil
}

// SQL backed storage engine using the database/sql functions only
type JSQL struct {
	Conn      *sql.DB
	GetStmt   *sql.Stmt
	StoreStmt *sql.Stmt
}

// Setup whatever is needed before calling Get/Store such as ensuring the
// DB is initialized and that we have prepare statements setup
func NewJSQL(conn *sql.DB) JSQL {
	m := JSQL{
		Conn: conn,
	}

	// Setup table if needed
	_, err := conn.Exec(`
    CREATE TABLE IF NOT EXISTS jsonnet (
      id varchar(40),
      code text,
      PRIMARY KEY (id)
    )
  `)
	if err != nil {
		panic(err)
	}

	stmt, err := conn.Prepare("SELECT (code) FROM jsonnet WHERE id = ? LIMIT 1")
	if err != nil {
		panic(err)
	}
	m.GetStmt = stmt

	stmt, err = conn.Prepare("INSERT INTO jsonnet (id, code) VALUES (?, ?) ON DUPLICATE KEY UPDATE id=?, code=?")
	if err != nil {
		panic(err)
	}
	m.StoreStmt = stmt

	return m
}

func (m JSQL) Get(id string) (string, error) {
	row := m.GetStmt.QueryRow(id)
	var code string
	if err := row.Scan(&code); err == nil {
		return code, nil
	}
	return code, DatastoreNoSuchID
}

func (m JSQL) Store(id string, code string) error {
	_, err := m.StoreStmt.Exec(id, code, id, code)
	if err != nil {
		return err
	}
	return nil
}
