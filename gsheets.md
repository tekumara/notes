# Google Sheets API

- Enable access for Google Drive & Google Sheets APIs for your project via [GCP Console for APIs](https://console.developers.google.com/apis/)
- Service accounts don't have access to existing files in Google Drive. They only have access to what they have created, or documents explicitly shared with the service account's email address, which looks like `user@project-123456.iam.gserviceaccount.com` - see example of setting this up [here](https://github.com/juampynr/google-spreadsheet-reader)
- When using Oauth, you can connect as an existing Google Drive user, and have access to everything they have. You need to follow an authentication flow that involves opening a browser, which grants a token that will expire.

Reference

- [Introduction to the Google Sheets API](https://developers.google.com/sheets/api/guides/concepts)
- [Authorize Requests](https://developers.google.com/sheets/api/guides/authorizing)
- [Authorizing pygsheets](https://pygsheets.readthedocs.io/en/stable/authorization.html)
