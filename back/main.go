package main

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	db, err := sql.Open(
		"mysql",
		// "root:175'@'SouthbeltEW@tcp(199.19.75.193:3306)/eastwest")
		// "root:175\@SouthbeltEW@tcp(199.19.75.193:3306)/eastwest")
		"root:'175@SouthbeltEW'@tcp(199.19.75.193:3306)/eastwest")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()
	rows, err := db.Query("CALL `eastwest`.`Sel_items`();")
	if err != nil {
		fmt.Println(err)
	} else {
		for rows.Next() {
			var name string
			err = rows.Scan(&name)
			if err != nil {
				panic(err.Error())
			}
			fmt.Println(name)
		}
	}
}
