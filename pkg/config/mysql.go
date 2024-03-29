package config

import (
	"fmt"
	"stock-photo-api/pkg/env"
)

type MySQL struct {
	DBName       string
	DBUser       string
	DBPassword   string
	DBHost       string
	DebugMode    bool
	MaxOpenConns int
	MaxIdleConns int
}

func NewMySQLConfig(env env.Env) MySQL {
	var DBHost string

	if env.Env == "local" {
		DBHost = fmt.Sprintf("tcp(%s)", env.DBHost)
	} else {
		DBHost = fmt.Sprintf("unix(/cloudsql/%s)", env.DBHost)
	}

	return MySQL{
		DBName:       env.DBName,
		DBUser:       env.DBUser,
		DBPassword:   env.DBPassword,
		DBHost:       DBHost,
		DebugMode:    env.DebugMode,
		MaxOpenConns: env.MaxOpenConns,
		MaxIdleConns: env.MaxIdleConns,
	}
}
