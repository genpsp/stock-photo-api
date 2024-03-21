package handlers

import (
	"net/http"
	"stock-photo-api/services/admin/src/handlers/request"
	"stock-photo-api/services/admin/src/services"

	"github.com/labstack/echo/v4"
)

type (
	Image interface {
		FindAll(c echo.Context) (err error)
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

// @Summary     画像一覧取得
// @Description アップロードされた画像の一覧を返す
// @Tags        images
// @Success     200 {array} model.Image
// @Failure     500 {object} echo.HTTPError
// @Router      /api/images [get]
func (h *imageStruct) FindAll(c echo.Context) (err error) {
	results, err := h.ImageService.FindAll()
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.JSON(http.StatusOK, results)
}

// @Summary     画像アップロード
// @Description リクエストされた画像をGCSにアップロードする
// @Tags        images
// @Accept		multipart/form-data
// @Param 		title formData string true "画像タイトル"
// @Param 		file formData file true "画像ファイル"
// @Success     204
// @Failure     500 {object} echo.HTTPError
// @Router      /api/images/upload [post]
func (h *imageStruct) Upload(c echo.Context) (err error) {
	title := c.FormValue("title")
	file, err := c.FormFile("file")
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	req := request.PostApiImagesUploadRequest(title, file)

	if err := h.ImageService.Upload(req); err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.NoContent(http.StatusNoContent)
}
