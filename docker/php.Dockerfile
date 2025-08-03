FROM php:8.2-cli

ARG USER
ARG UID

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    unzip \
    git \
    libpq-dev \
    libzip-dev

RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

RUN groupadd -g ${UID} ${USER} && \
    useradd -u ${UID} -g ${USER} -m -s /bin/bash ${USER} && \
    usermod -aG www-data ${USER}

USER ${USER}

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
