package database

import (
	"errors"
	"fmt"
	"stock-photo-api/src/pkg/config"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type Database struct {
	Master *gorm.DB
}

func (d *Database) Close() {
	closedDB, _ := d.Master.DB()
	if err := closedDB.Close(); err != nil {
		errors.New("")
	} else {
		errors.New("")
	}
}

func dataSource(userName string, password string, host string, dbName string) string {
	return fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8mb4&parseTime=True&loc=Local", userName, password, host, dbName)
}

func Open(cfg config.MySQL) Database {
	master, err := gorm.Open(
		mysql.Open(
			dataSource(cfg.DBUser, cfg.DBPassword, cfg.DBHost, cfg.DBName),
		),
	)
	if err != nil {
		errors.New("")
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
