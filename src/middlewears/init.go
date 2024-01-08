package middlewares

import (
	"github.com/labstack/echo/v4"
)

type (
	Auth interface {
		RequireJWTAuthorizationHeader() echo.MiddlewareFunc
	}

	authImpl struct {
	}
)

func NewAuth() Auth {
	return &authImpl{}
}

type JWTContext struct {
	echo.Context
}

func (s *authImpl) RequireJWTAuthorizationHeader() echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			// firebaseJWT := c.Request().Header.Get("Authorization")

			// jc := &JWTContext{c, &jwt.Token{UID: token.UID}}

			// c.Set("token", jc.Token)
			return next(c)
		}
	}
}
