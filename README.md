# speechiebot-api

## Dependencies

* sox
* opus-tools

> Note: sox must be installed with flac support

To install these dependencies in macOS read through the following links:

*sox*: https://apple.stackexchange.com/questions/137108/how-can-i-add-support-for-flac-files-in-sox

*opus-tools*: http://brewformulas.org/OpusTools

## Environment

A `.env` file must be created in the root directory and the following values must be set:

* TELEGRAM_TOKEN=<telegram_token>
* BOT_USERNAME=@<bot_username>
* GOOGLE_SPEECH_API_KEY=<google_speech_api_key>
