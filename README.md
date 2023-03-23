# Upload file to Google Drive

Use this Bitrise step to upload a file to Google Drive folder. You can choose to upload either a XML or HTML file, depending on your needs.

## Requirements

- Prepare [Google Service account](https://cloud.google.com/iam/docs/service-accounts-create) and enable  [Google Drive API](https://developers.google.com/drive/api/guides/enable-sdk).
- Create a new folder on your Google Drive and share it with service email which was provided after creating Google Service account.
- This step uses next input variables:
    1. `Location to file` : The path where the file is located.
    2. `Output file` : The name for uploaded file to the Google Drive.
    3. `Content Type` : The type for the output file, ether XML or HTML.
    4. `Service Account Private Key` : The secret key which was provided for your Google Service account. **Do not save this value in `Env Vars`, use `Secrets`.**
    5. `Service Account ID` : In other words the service email which was provided for your Google Service account.
    6. `Google Drive Directory ID` : Google Drive folder ID. Usually looks like this: `https://drive.google.com/drive/u/0/folders/ID_OF_THE_FOLDER`.

## How to use this Step

Simply add this step inside your `bitrise.yml` file as follows:
`git::https://github.com/URL/to/this/repository.git: {}`

Use this code snippet as reference:

```yaml
workflows:
  "name_of_your_workflow":
    steps:
      # .... 
      - git::https://github.com/nttr-mypocket/bitrise_step_google_drive_upload.git: {}
      # ....
```

Then add all required variables according to the Requirements, and we are good to go!

## Outputs

The step generates the following output variable:

- `$GOOGLE_DRIVE_OUTPUT_URL` : The URL to the Google Drive folder.

=======
That's all ;)

## Copyright

Copyright © 2023 NTT Resonant Technology Inc. All Rights Reserved.
