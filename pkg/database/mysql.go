package database

import (
	"fmt"
	"log"
	"stock-photo-api/pkg/config"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type Database struct {
	Master *gorm.DB
}

func Open(cfg config.MySQL) Database {
	master, err := gorm.Open(
		mysql.Open(dsn(cfg.DBUser, cfg.DBPassword, cfg.DBHost, cfg.DBName)),
	)
	if err != nil {
		log.Fatal(err)
	}
	if cfg.DebugMode {
		master = master.Debug()
	}

	dbConfig, _ := master.DB()

	dbConfig.SetMaxOpenConns(cfg.MaxOpenConns)
	dbConfig.SetMaxIdleConns(cfg.MaxIdleConns)
	dbConfig.SetConnMaxLifetime(30 * time.Minute)

	return Database{
		Master: master,
	}
}

func (d *Database) Close() {
	closedDB, _ := d.Master.DB()
	if err := closedDB.Close(); err != nil {
		log.Fatal(err)
	} else {
		log.Fatal(err)
	}
}

func dsn(userName string, password string, host string, dbName string) string {
	return fmt.Sprintf("%s:%s@%s/%s?charset=utf8mb4&parseTime=True&loc=Local", userName, password, host, dbName)
}
