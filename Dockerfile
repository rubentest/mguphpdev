FROM nanoninja/php-fpm:7.3.10
WORKDIR /web
RUN echo 'date.timezone = "Europe/Madrid"' > /usr/local/etc/php/conf.d/php-timezone.ini && ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && apt update && apt install -y vim curl iputils-ping telnet && mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales && echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=es_ES.UTF-8

RUN echo 'session.cookie_domain=.farmapremium.es' >> /usr/local/etc/php/php.ini
RUN echo 'session.save_handler = redis' >> /usr/local/etc/php/php.ini
RUN echo 'session.save_path = tcp://redis:6379' >> /usr/local/etc/php/php.ini

# Install APT basic packages
RUN apt install -y curl git-all unzip vim gnupg bash-completion zlib1g-dev libicu-dev

# Install APT repositories
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install APT packages nodejs & yarn
RUN apt-get update && apt-get install -y nodejs yarn npm && mkdir -p /root/.sonar/native-sonar-scanner

# Sonar Scanner
RUN npm i -g sonarqube-scanner

#Sonar Scanner Client
ADD https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.0.0.1744-linux.zip /root/.sonar/native-sonar-scanner/

RUN unzip /root/.sonar/native-sonar-scanner/sonar-scanner-cli-4.0.0.1744-linux.zip -d /root/.sonar/native-sonar-scanner/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

COPY ./php-xdebug.ini /usr/local/etc/php/conf.d/php-xdebug.ini
COPY ./php-redis.ini /usr/local/etc/php/conf.d/php-redis.ini

