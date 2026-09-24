FROM httpd:latest

# This is where the files are mounted to later.
RUN mkdir /data

# Turn on fancy directory listings (with sortable columns).
RUN sed -i "s|#Include conf/extra/httpd-autoindex.conf|Include conf/extra/httpd-autoindex.conf|" /usr/local/apache2/conf/httpd.conf

# Turn off automatically loading index.html etc.
RUN sed -i "s|LoadModule dir_module modules/mod_dir.so|#LoadModule dir_module modules/mod_dir.so|" /usr/local/apache2/conf/httpd.conf

# Change document root to the mounted directory (/data).
RUN sed -i "s|DocumentRoot \"/usr/local/apache2/htdocs\"|DocumentRoot \"/data\"|" /usr/local/apache2/conf/httpd.conf

# Create the new <Directory> section. (We keep the <Directory "/usr/local/apache2/htdocs"> as it is. It's now unused anyway.)
RUN cat <<EOF >> /usr/local/apache2/conf/httpd.conf
<Directory "/data">
  Options Indexes
  IndexOptions Charset=UTF-8
  IndexOptions NameWidth=*
  AllowOverride AuthConfig
  Require all granted
</Directory>
EOF

