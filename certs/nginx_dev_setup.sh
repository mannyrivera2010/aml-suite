
mkdir -p ~/usr/local/

# Download nginx-1.9.4.tar.gz
tar xvf nginx-1.9.4.tar.gz

# Installing ngnix
cd nginx-1.9.4
./configure --with-http_ssl_module --prefix=`echo ~`/usr/local/ngnix
make
make install


mv ~/usr/local/ngnix/conf/nginx.conf ~/usr/local/ngnix/conf/nginx.conf.bak1

ln -s ~/git/dev-tools/certs/nginx/nginx.conf ~/usr/local/ngnix/conf/nginx.conf
ll ~/usr/local/ngnix/conf/


mkdir -p ~/init.d/
# Create Sym link for init script for nginx

rm ~/init.d/nginx
ln -s ~/git/dev-tools/certs/nginx/nginx ~/init.d/nginx

# VERIFY that sym link exist
ll ~/init.d/
