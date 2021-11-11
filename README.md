# VOD2Live demo 
Simple demo showing off Remix VOD2Live. Uses a modified Unified Origin image
which includes processing of input SMIL playlists to produce a Remix mp4 and
creating a VOD2Live .isml for streaming.

## Repo structure
The repository should contain at least:
* ``docker/`` directory with a subdirectory for each Docker image being built
* ``smils/`` directory containing SMIL file(s) which will be turned in to VOD2Live channels
* ``docker-compose.yaml``
* ``README.md`` explaining how to use the project

## Usage
Add, or edit, SMIL files in ``smils/`` directory.

Set your license key (must include Remix and VOD2Live functionality) with
``export UspLicenseKey=<KEY>``. If you don't already have a license but want
to evaluate Remix VOD2Live, please contact sales@unified-streaming.com.

Start with ``docker-compose up -d``.

View logs with ``docker-compose logs``. This should show output from Remix and
mp4split preparing the VOD2Live channel, and then the webserver starting up:

```
origin_1  | Status: 200 FMP4_OK
origin_1  | [Thu Nov 11 15:43:17.442344 2021] [ssl:warn] [pid 1] AH01873: Init: Session Cache is not configured [hint: SSLSessionCache]
origin_1  | [Thu Nov 11 15:43:17.442915 2021] [smooth_streaming:notice] [pid 1] License key found: /etc/usp-license.key
origin_1  | [Thu Nov 11 15:43:17.444826 2021] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.51 (Unix) OpenSSL/1.1.1l USP/1.11.9 IISMS/4.0 configured -- resuming normal operations
origin_1  | [Thu Nov 11 15:43:17.444868 2021] [core:notice] [pid 1] AH00094: Command line: 'httpd -D FOREGROUND'
```

Access demo page at ``http://localhost/`` (replace localhost with address if
not running locally). By default this will start playing the
``smils/unified-learning.smil`` channel.

If you want a different playlist to be used, you can change this in
``docker/origin/index.html``.
