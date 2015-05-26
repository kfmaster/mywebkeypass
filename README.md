## Original Author and MAINTAINER is: James Jones "velocity303@gmail.com"
    Slightly modifed by MAINTAINER kfmaster "fuhaiou@hotmail.com" to adapt my own use case.

## I made following changes to the original image:
    (1) Add more cpanm related module to overcome build errors on my cloud service provider's platfrom;
    (2) Add a reverse proxy based on nginx to overcome port assignment limit on my cloud provider's platform;
    (3) Add a process to retreive .kdb files from another container running web server that collects user uploads;
    (4) Add supervisord to bring above 3 processes under control of supervisord

    The entry point is /start.sh, which calls the supervisord, see supervisord.conf for more details. Following are some notes:

    In order for nginx to be controled by supervisord, I need add "daemon off;" to the main nginx.conf to run nginx in foreground;
    I am experimenting on process group feature in supervisord, however it seems the supervisord version comes with this image is 
    3.0b2 and does not properly support the process group stop as group feature; I still have to stop/restart process individually. 
    I will try to install latest supervisord from github to try again;
    I exposed port 9001 for supervisord, the default login is set to: admin/Secret123 .      

webkeepass-docker
=================

Docker container for WebKeePass

This project is a container for the WebKeePass project created by sukria found here: https://github.com/sukria/WebKeePass

More information on his project can also be found on his blog post below:
http://blog.sukria.net/2013/08/27/webkeepass-or-how-to-build-your-own-cloud-aware-keyring/

The port that the server will run on by default is 5001 and a reverse proxy should be set up to run this under SSL.

There is one volume referenced as /keepass and this should contain your KeePass database file, in this setup named MyKeePass.kdbx. The production.yml file can be modified however if building from source to refer to a name of your choosing.

This container can be run by issuing the following command:

docker run -d --name webkeepass -p 5001:5001 -v /path/containing/keepassfile:/keepass  velocity303/webkeepass-docker


