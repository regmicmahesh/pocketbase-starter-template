package migrations

import (
	"os"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/daos"
	m "github.com/pocketbase/pocketbase/migrations"
)

func init() {
	m.Register(func(db dbx.Builder) error {

		dao := daos.New(db)
		settings, err := dao.FindSettings()
		if err != nil {
			return err
		}

		if os.Getenv("SMTP_HOST") != "" {
			settings.Smtp.Host = os.Getenv("SMTP_HOST")
			settings.Smtp.Enabled = true
		}
		settings.Smtp.Username = os.Getenv("SMTP_USERNAME")
		settings.Smtp.Password = os.Getenv("SMTP_PASSWORD")
		settings.Smtp.Port = 587

		settings.Smtp.AuthMethod = "PLAIN"
		settings.Smtp.Tls = false

		return dao.SaveSettings(settings)

	}, func(db dbx.Builder) error {

		return nil
	})
}
