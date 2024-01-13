package config

import (
	"fmt"
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
	DBInstanceID := env.DBInstanceID
	DBHost := env.DBHost

	switch env.Env {
	case "dev", "stg", "prd":
		DBHost = fmt.Sprintf("unix(/cloudsql/%s)", DBInstanceID)
	default:
		DBHost = fmt.Sprintf("tcp(%s)", DBHost)
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
