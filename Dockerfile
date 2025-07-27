FROM node:12.22.6-buster

# 替换源为 archive，解决 buster 失效问题
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y ruby-full build-essential libpq-dev

WORKDIR /app

COPY .yarnrc ./  
COPY package.json yarn.lock ./  
RUN yarn install --ignore-engines

COPY . .

RUN yarn build || yarn webpack

# ✅ 指定 bundler 版本
RUN gem install bundler -v 2.3.27 && bundle _2.3.27_ install

# ✅ 设置运行环境变量
ENV RAILS_ENV=production

# ✅ 创建 Puma 需要的临时目录
RUN mkdir -p tmp/pids

EXPOSE 3000

# ✅ 启动 Rails 应用
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
