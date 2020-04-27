~~# youtube-local~~

~~> Local version of youtubes subscription feed; manage new videos in vim and watch with vlc~~

~~Using youtubes api, this collection of scripts scrapes the channels of your subscribed youtubers for new videos, relative to the last time the script ran. New videos will be collected in a file, and using a vim script you start the videos with vlc.~~

## Replaced by newsboat + youtube RSS feeds

<details>
<summary><strong>Table of Contents</strong></summary>

<!-- toc -->

- [Motivation](#motivation)
- [Setup](#setup)
  * [Clone the repo](#clone-the-repo)
  * [Youtube API key](#youtube-api-key)
  * [Add your subscriptions](#add-your-subscriptions)
  * [Finish](#finish)
  * [Vim play script](#vim-play-script)
- [Usage](#usage)
- [How it works](#how-it-works)
- [Utility Scripts (for easier usage)](#utility-scripts-for-easier-usage)
  * [Add video](#add-video)
  * [Align videos](#align-videos)

<!-- tocstop -->

</details>


## Motivation

- My browser automatically deletes cookies, history, everything once I quit it. So to watch youtube I have to login every time.
- I watch videos with my bluetooth speaker and you can't adjust the latency on youtube (unlike vlc).
- Once I'm on youtube, I tend to watch a lot more videos than just those in my subscription feed.
- I like to do everything with my keyboard. Youtube sometimes forces me to use my touchpad.

## Setup

**Dependencies:**
- [node](https://github.com/nodejs/node)
- [jq](https://github.com/stedolan/jq)

### Clone the repo

```
git clone https://github.com/jneidel/youtube-local.git
cd youtube-local
```

### Youtube API key

- Follow [these instructions](https://developers.google.com/youtube/v3/getting-started#before-you-start) to generate your api key
- Move `env.json.example` to `env.json` and insert your key

### Add your subscriptions

- Go to a list of your subscriptions (eg. on your channel -> subscriptions) and click through to a channel
- If you have the `youtube.com/channel/xxx` url take the id off the end (eg. `UC-lHJZR3Gqxm24_Vd_AJ5Yw` from `https://www.youtube.com/channel/UC-lHJZR3Gqxm24_Vd_AJ5Yw`)
- If you have the `youtube.com/user/xxx` url, click on a video and go through their channel icon below the video back to the channel. Now you should have the url in the `youtube.com/channel/xxx` format
- Add the channelId (beginning with UC...) to a newly created `CHANNELS` file (be sure to leave a comment so you know what the id corresponds to)

[View CHANNEL.example](https://github.com/jneidel/youtube-local/blob/master/CHANNELS.example) for channelId and playlist examples

After you've added all channels run `./generate-channel-list.js` to remove comments and replace channelId with the users uploads playlist.

### Finish

Run `./setup.sh` to generate need data files.

The 'last activity' will be set to right now (only videos released from this point on will be matched). If you want to change that edit `data/LAST_UPDATE`.

### Vim play script

I wrote a vim script, that enables you to open `./videos` in vim and start playing the video under the cursor with a keyboard shortcut.

```vim
let mapleader = "#"
" Play youtube-link in current line with '#y':
map <leader>y /http<Enter>:noh<Enter>"1y$0:!vlc -q --fullscreen "<C-R>1"<cr>
```

[View my current script](https://github.com/jneidel/dotfiles/blob/master/manjaro/.vim/config/yt.vim) (includes download & more vlc args)

## Usage

Run `./download-loop.sh` to check for new videos.

View `./videos` to watch new videos.

## How it works

It scrapes the channels "Uploads from xxx" playlist, to which newly published videos are automatically added ([Example](https://www.youtube.com/playlist?list=UU-lHJZR3Gqxm24_Vd_AJ5Yw)).

This means that you can also add any playlist. If, for example, you don't want to see all uploads from a channel, but only one of their series ([Example](https://www.youtube.com/playlist?list=PLlRceUcRZcK0E1Id3NHchFaxikvCvAVQe)).

Application of these examples: [CHANNEL.example](https://github.com/jneidel/youtube-local/blob/master/CHANNELS.example).

## Utility Scripts (for easier usage)

### Add video

Given a youtube link, this script will add that video to the `videos` file. Includes fetching channel/video name.

```
$ ./bin/add-video.sh https://www.youtube.com/watch?v=fORh5rodVSg
$ tail ./videos
#-> pewdiepie: G R E E N T E X T https://www.youtube.com/watch?v=fORh5rodVSg
```

I use this script through [another script](https://github.com/jneidel/dotfiles/blob/master/manjaro/scripts/i3/clipboard/clipboard-add-yt-video.sh), which will get the current clipboard content pass it to `add-video.sh`.

### Align videos

This script will format videos in the `videos` file to align each title and url horizontally:

```
pewdiepie: INSERT CLICKBAIT HERE https://www.youtube.com/watch?v=FK5pjkUP6t8
channel:   video title           https://www.youtube.com/watch?v=oQ28ZolgeaI
me:        meh                   https://www.youtube.com/watch?v=oQ28ZolgeaI
```

This script should be used in conjunction with a vim visual selection:

```
From this scripts --help:

Example (in vim):
Select all videos (normal mode): gg v G
:'<,'> !~/path/to/youtube-local/bin/align-videos.sh
```

View script at: [bin/align-videos.sh](bin/align-videos.sh)

View how I integrate it in my workflow: [yt.vim](https://github.com/jneidel/dotfiles/blob/master/manjaro/.vim/config/yt.vim#L11)

