package handlers

import (
	"net/http"
	"stock-photo-api/src/services"

	"github.com/labstack/echo/v4"
)

type (
	Image interface {
		Upload(c echo.Context) (err error)
	}
	imageStruct struct {
		ImageService services.ImageService
	}
)

func NewImage(s services.ImageService) Image {
	return &imageStruct{
		ImageService: s,
	}
}

// @Summary     画像アップロード
// @Description リクエストされた画像をGCSにアップロードする
// @Tags        images
// @Accept			multipart/form-data
// @Param 			title formData string true "画像タイトル"
// @Param 			file formData file true "画像ファイル"
// @Success     204
// @Failure     500 {object} echo.HTTPError
// @Router      /api/images/upload [post]
func (h *imageStruct) Upload(c echo.Context) (err error) {
	if err := h.ImageService.Upload(); err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.NoContent(http.StatusNoContent)
}
