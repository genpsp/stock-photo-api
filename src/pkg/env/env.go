package env

import (
	"os"
	"strconv"
)

type Env struct {
	Env          string
	DBName       string
	DBUsername   string
	DBPassword   string
	DBInstanceID string
	DebugMode    bool
	MaxOpenConns int
	MaxIdleConns int
}

func NewEnv() Env {
	debugMode, _ := strconv.ParseBool(os.Getenv("DEBUG_MODE"))
	maxOpenConns, _ := strconv.Atoi(os.Getenv("MAX_OPEN_CONNS"))
	maxIdleConns, _ := strconv.Atoi(os.Getenv("MAX_IDLE_CONNS"))

	return Env{
		Env:          os.Getenv("ENV"),
		DBName:       os.Getenv("DB_NAME"),
		DBUsername:   os.Getenv("DB_USER_NAME"),
		DBPassword:   os.Getenv("DB_PASSWORD"),
		DBInstanceID: os.Getenv("DB_INSTANCE_ID"),
		DebugMode:    debugMode,
		MaxOpenConns: maxOpenConns,
		MaxIdleConns: maxIdleConns,
	}
}
