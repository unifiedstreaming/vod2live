# VOD2Live demo 
Simple demo showing off Remix VOD2Live. Uses a modified Unified Origin image
which includes processing of input SMIL playlists to produce a Remix mp4 and
creating a VOD2Live .isml for streaming.

## Repo structure
The repository should contain at least:
* docker/ directory with a subdirectory for each Docker image being built
* smils/ directory containing SMIL file(s) which will be turned in to VOD2Live channels
* docker-compose.yaml
* README.md explaining how to use the project

## Usage
Add, or edit, SMIL files in ``smils/`` directory.

Start with ``docker-compose up -d``.

View logs with ``docker-compose logs``.

Access demo page at ``http://<address>/``. By default this will start playing the
``smils/unified-learning.smil`` channel.

If you want a different playlist to be used, you can change this in
``docker/origin/index.html``.
