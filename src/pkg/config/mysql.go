package config

import (
	"fmt"
	"os"
	"stock-photo-api/src/pkg/env"
)

type MySQL struct {
	DBName       string
	DBUsername   string
	DBPassword   string
	DBHost       string
	DBInstanceID string
	DebugMode    bool
	MaxOpenConns int
	MaxIdleConns int
}

func NewMySQLConfig(env env.Env) MySQL {
	var DBHost string

	switch env.Env {
	case "dev", "stg", "prd":
		DBHost = fmt.Sprintf("unix(/cloudsql/%s)", os.Getenv("CLOUD_SQL_INSTANCE"))
	default:
		DBHost = fmt.Sprintf("tcp(%s)", os.Getenv("DB_HOST"))
	}

	return MySQL{
		DBName:       env.DBName,
		DBUsername:   env.DBUsername,
		DBPassword:   env.DBPassword,
		DBHost:       DBHost,
		DBInstanceID: env.DBInstanceID,
		DebugMode:    env.DebugMode,
		MaxOpenConns: env.MaxOpenConns,
		MaxIdleConns: env.MaxIdleConns,
	}
}
