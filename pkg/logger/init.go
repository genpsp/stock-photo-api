package logger

import (
	"errors"

	"go.uber.org/zap"
)

type Logger struct {
	Logger *zap.Logger
}

func Init() (*zap.Logger, error) {
	logger, err := zap.NewProduction()
	if err != nil {
		return nil, errors.New("")
	}

	return logger, nil
}
