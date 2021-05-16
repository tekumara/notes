<div title="Google Sheets API" creator="YourName" modifier="YourName" created="201710310518" modified="201710310519" changecount="4">
<pre>* Enable access for Google Drive &amp; Google Sheets APIs for your project via https://console.developers.google.com/apis/
* Service accounts don't have access to existing files in Google Drive. They only have access to what they have created, or documents explicitly shared with the service account's email address, which looks like {{{user@project-123456.iam.gserviceaccount.com}}} - see example of setting this up [[here|https://github.com/juampynr/google-spreadsheet-reader]]
* When using Oauth, you can connect as an existing Google Drive user, and have access to everything they have. You need to follow an authentication flow that involves opening a browser, which grants a token that will expire.
</pre>
</div>
