# Upload Android Lint Report to Google Drive

Use this Bitrise step to upload the Android Lint report to a Google Drive folder. You can choose to upload either the XML or HTML report, depending on your needs.

## Requirements

- This step must be executed after the [report analyzer](https://github.com/nttr-mypocket/bitrise_step_analyze_android_lint) step in the Bitrise workflow, as it requires a report file which was processed previously, otherwise the step will fail.
- Prepare [Google Service account](https://cloud.google.com/iam/docs/service-accounts-create) and enable  [Google Drive API](https://developers.google.com/drive/api/guides/enable-sdk).
- Create a new folder on your Google Drive and share it with service email which was provided after creating Google Service account.
- This step uses next input variables:
    1. `Location to file` : The path where the report file was created.
    2. `Output file` : The name for uploaded file to the Google Drive.
    3. `Content Type` : The type for the output file, ether XML or HTML.
    4. `Service Account Private Key` : The secret key which was provided for your Google Service account. **Do not save this value in `Env Vars`, use `Secrets`.**
    5. `Service Account ID` : In other words the service email which was provided for your Google Service account.
    6. `Directory ID` : Google Drive folder ID. Usually looks like this: `https://drive.google.com/drive/u/0/folders/ID_OF_THE_FOLDER`.

## How to use this Step

To use the step, you must first add it to your Bitrise workflow after the [report analyzer](https://github.com/nttr-mypocket/bitrise_step_analyze_android_lint) step.

Simply add this step inside your `bitrise.yml` file as follows:
`git::https://github.com/URL/to/this/repository.git: {}`

Use this code snippet as reference:

```yaml
workflows:
  "name_of_your_workflow":
    steps:
      # .... 
      - android-lint@0: {}
      - git::https://github.com/URL/to/report/analyzer/repository.git: {}
      - git::https://github.com/nttr-mypocket/bitrise_step_google_drive_upload.git: {}
      # ....
```

Then add all required variables according to the Requirements, and we are good to go!

## Outputs

The step generates the following output variable:

- `$GOOGLE_DRIVE_OUTPUT_URL` : The URL to the report file on the Google Drive.
