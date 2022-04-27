# Create Installation Directory under
mkdir -p ~/usr/local/
# Download nginx-1.9.4.tar.gz
# wget ....
# Untar tar file
tar xvf nginx-1.9.4.tar.gz
# Install ngnix
cd nginx-1.9.4
./configure --with-http_ssl_module --prefix=`echo ~`/usr/local/ngnix
make
make install
# backup old nginx
mv ~/usr/local/ngnix/conf/nginx.conf ~/usr/local/ngnix/conf/nginx.conf.bak1
# Create Symlink of nginx conf in installation directory
ln -s ~/git/dev-tools/certs/nginx/nginx.conf ~/usr/local/ngnix/conf/nginx.conf
# VERIFY files are in nginx configuration folder
ll ~/usr/local/ngnix/conf/
# Create Home Init.d folder
mkdir -p ~/init.d/
# Remove Old symlink
rm ~/init.d/nginx
# Create Sym link for init script for nginx
ln -s ~/git/dev-tools/certs/nginx/nginx ~/init.d/nginx
# VERIFY that sym link exist
ll ~/init.d/
