package config

import (
	"stock-photo-api/src/pkg/env"
	"sync"
)

type Config struct {
	GCS
	MySQL
}

func LoadConfig() Config {
	var c Config
	var once sync.Once

	once.Do(func() {
		env := env.NewEnv()

		c = Config{
			GCS:   NewGCSConfig(env),
			MySQL: NewMySQLConfig(env),
		}
	})

	return c
}
