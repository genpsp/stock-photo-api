package config

import (
	"fmt"
	"os"
	"stock-photo-api/src/pkg/env"
)

type GCS struct {
	DBName       string
	DBUsername   string
	DBPassword   string
	DBHost       string
	DBInstanceID string
}

func NewGCSConfig(env env.Env) GCS {
	var DBHost string

	switch env.Env {
	case "dev", "stg", "prd":
		DBHost = fmt.Sprintf("unix(/cloudsql/%s)", os.Getenv("CLOUD_SQL_INSTANCE"))
	default:
		DBHost = fmt.Sprintf("tcp(%s)", os.Getenv("MYSQL_MASTER_HOST"))
	}

	return GCS{
		DBName:       env.DBName,
		DBUsername:   env.DBUsername,
		DBPassword:   env.DBPassword,
		DBHost:       DBHost,
		DBInstanceID: env.DBInstanceID,
	}
}
