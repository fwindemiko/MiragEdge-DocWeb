FROM php:8-fpm-alpine

# 1. 安装 GD 及其它扩展所需的系统依赖库
RUN apk add --no-cache \
    zlib-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libwebp-dev \
    libxpm-dev \
    libzip-dev \
    oniguruma-dev   # mbstring 可能需要，WordPress 推荐

# 2. 配置 GD 扩展（启用对 jpeg, png, freetype, webp, xpm 的支持）
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    --with-xpm

# 3. 安装 PHP 扩展（按需调整）
RUN docker-php-ext-install \
    mysqli \
    pdo_mysql \
    gd \
    exif \
    zip \
    mbstring         # WordPress 推荐

# 4. （可选）安装 Redis 等第三方扩展（如果需要）
# RUN pecl install redis && docker-php-ext-enable redis

# 5. 清理缓存（减少镜像体积）
RUN rm -rf /var/cache/apk/*

# 6. 设置时区（可选）
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

# 7. 使用非 root 用户运行（官方镜像默认已是 www-data）
USER www-data