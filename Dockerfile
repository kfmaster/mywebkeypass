FROM library/ubuntu:latest
# Original Author and MAINTAINER is: James Jones "velocity303@gmail.com"
MAINTAINER kfmaster "fuhaiou@hotmail.com"

RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf \
&& echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf \
&& echo 'deb http://security.ubuntu.com/ubuntu trusty-security main' >> /etc/apt/sources.list \
&& apt-get -y update \
&& apt-get install -qy git wget build-essential openssl expat libexpat1-dev libssl-dev libxml-parser-perl nginx supervisor \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY perlbrew.sh /usr/bin/perlbrew.sh
RUN chmod +x /usr/bin/perlbrew.sh \
&& bash /usr/bin/perlbrew.sh

RUN ~/perl5/perlbrew/bin/perlbrew init \
&& ~/perl5/perlbrew/bin/perlbrew --force install -n `~/perl5/perlbrew/bin/perlbrew available | head -1` --as webkeepass -j 3 \
&& ~/perl5/perlbrew/bin/perlbrew use webkeepass

COPY cpanm /opt/cpanm
RUN chmod +x /opt/cpanm

RUN ln -s /opt/cpanm /usr/bin/ \
&& mkdir -p /srv/webkeepass/WebKeePass 

RUN cd /srv/webkeepass; cpanm Moose::Role \
&& cpanm MooseX::Types \ 
&& cpanm Config::MVP \ 
&& cpanm Moose::Util \
&& cpanm MooseX::LazyRequire \
&& cpanm Perl::PrereqScanner \
&& cpanm MooseX::SetOnce \
&& cpanm Data::Section \
&& cpanm Software::LicenseUtils \
&& cpanm Software::License \
&& cpanm Dancer2 \
&& cpanm Digest::SHA1 \ 
&& cpanm XML::Parser \ 
&& cpanm Dancer2::Plugin::Ajax \
&& cpanm File::KeePass \
&& cpanm Dist::Zilla 

ADD webkeepass.tar.gz /srv/webkeepass/
RUN cd /srv/webkeepass; /usr/local/bin/dzil authordeps | cpanm -nq && dzil listdeps | cpanm -nq 

RUN rm /srv/webkeepass/bin/app.pl 
RUN  rm /srv/webkeepass/lib/WebKeePass.pm

COPY app.pl /srv/webkeepass/bin/
COPY WebKeePass.pm /srv/webkeepass/lib/
COPY production.yml /srv/webkeepass/environments/
COPY proxy.conf /etc/nginx/conf.d/proxy.conf
COPY start.sh /
COPY retrieve_kdbfile.sh /root/retrieve_kdbfile.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# In order to use supervisord, nginx needs run in foreground
RUN chmod +x /srv/webkeepass/bin/app.pl \
&& echo "daemon off;" >> /etc/nginx/nginx.conf \
&& chmod +x /start.sh

VOLUME /keepass

# Port 80 for reverse proxy, port 5001 is webkeepass port, port 9001 is admin port for supervisord
EXPOSE 80 5001 9001

CMD ["/start.sh"]
