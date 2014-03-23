#
# Cookbook Name:: php54
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# remote_file: リモートサーバにあるファイルをhttp経由で取得し、指定した場所に保存する
# only_if: 評価結果が真の時に実行する
# not_if: 評価結果が偽の時に実行する

# xml2-config
pkgs = %w(gcc make zlib-devel readline-devel libxml2-devel openssl-devel curl-devel bzip2-devel)
filename = "php-5.4.0.tar.bz2"
remote_uri = "http://museum.php.net/php5/php-5.4.0.tar.bz2";

# パッケージのインストール
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

package "libmcrypt-devel" do
  version "2.5.8-9.el6"
  action :install
  options "--enablerepo=epel"
end

# ソースの取得
remote_file "/usr/src/#{filename}" do
  source "#{remote_uri}"
end

# インストール
bash "install_php54" do
  not_if "which php"
  cwd "/usr/src"

  code <<-EOL
    tar jxf #{filename}
    cd php-5.4.0
    ./configure --prefix=/usr --enable-maintainer-zts --with-pear --with-config-file-path=/etc --with-readline --with-mcrypt --with-zlib -enable-mbstring --with-curl --with-bz2 --enable-zip --enable-sockets --enable-sysvsem --enable-sysvshm --with-mhash --with-pcre-regex --with-gettext --enable-bcmath --enable-libxml --enable-json --with-openssl --enable-pcntl
    make && make install
  EOL
end

# 拡張ライブラリのインストール
bash "install_pthreads" do
  not_if "pecl list | grep pthreads"

  code <<-EOL
    pecl install channel://pecl.php.net/pthreads-0.0.44
  EOL
end

# 設定ファイル
template "php.ini" do
  path "/etc/php.ini"
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[httpd]'
end
