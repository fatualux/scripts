# My Scripts
### A small collection of scripts to speed up everyday tasks
##### Here are some scripts I often use (I assigned them shortcuts in my i3 wm config to speed up execution).
Most of them require the installation of **dunst** (https://github.com/dunst-project/dunst) to show a notification.
If you do not want/need this feature, you can comment/delete `/bin/dunstify <script title>` (`man dunst` for more info).

## translate.sh

It is a basic bash script which requires the installation of **translate-shell**, a command-line translator powered by *Google Translate* (default), *Bing Translator*, *Yandex.Translate*, and *Apertium* (https://github.com/soimort/translate-shell).

If executed, it opens a shell prompt, asks user for a text and translate it in Italian.
You can change the language by editing line 16 (`man trans` for more info)

## web_search.sh

It is a basic bash script which requires the installation of **w3m**, a text based web-browser.

If executed, it opens a shell prompt, asks user for a text and search that on *google.com*.
You can change the search engine by editing line 17.

## youtube-dl.sh

It is a basic bash script which requires the installation of **yt-dlp** (https://github.com/yt-dlp/yt-dlp), a tool designed to  download videos from *youtube.com* or other video platforms.

If executed, it opens a shell prompt, asks user for the video url and lists all available format of the medium.
Then, it asks the user to choose between five common video/audio formats and for a name to give to the downloaded file, and saves it to the user's home directory.

## media-cofverter.sh

It is a basic bash script which requires the installation of **ffmpeg**, a collection of libraries and tools to process multimedia content (https://github.com/FFmpeg/FFmpeg).
If executed, it opens a shell prompt, asks user to enter the path/to/the/file and to choose between six common extensions for the output file.

## whisper.sh

It is a basic bash script to transcribe/translate (English only) a video/audio file.
It is based on **OpenAI Whisper** (https://github.com/openai/whisper) and requires the pre-trained models to be downloaded (only the first time we choose them).
PT models' directory can be specified with the ` --model_dir` option (the default location where models are downloaded and searched for is *"$HOME"/.cache/whisper/*).
You have to install this packages to get this script working properly:
```
dunst python3 python-pip ffmpeg
```
You have to install the following modules:
```
pip install setuptools-rust
pip install git+https://github.com/openai/whisper.git
```
To update whisper:
```
pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git
```
See docs at https://github.com/openai/whisper

## archBackup.sh

It is a basic bash script which requires the installation of `pacman` and `tar`, intended to speed up backing up of packages and configs.
By editing line 18 and line 19 you can modify the lists of files and folders according to your needs.
It also creates two different text files containing the names of the packages installed, from official repo as far as AUR/manually installed.


## yt-downloader.sh

It is a basic bash script which requires the installation of **yt-dlp** and **ffmpeg**.
If is meant to speed up the download of a video file from the Internet, to extract an audio from a video file, or to convert a media file to a different format.
