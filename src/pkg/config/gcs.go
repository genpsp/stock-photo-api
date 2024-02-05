package config

import (
	"stock-photo-api/src/pkg/env"
)

type GCS struct {
	DBName       string
	DBUser       string
	DBPassword   string
	DBHost       string
	DBInstanceID string
}

func NewGCSConfig(env env.Env) GCS {
	return GCS{
		DBName:       env.DBName,
		DBUser:       env.DBUser,
		DBPassword:   env.DBPassword,
		DBInstanceID: env.DBInstanceID,
	}
}
