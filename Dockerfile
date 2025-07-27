# 使用 Node.js 12 + Debian Buster 镜像
FROM node:12.22.6-buster

# ✅ 替换 Debian 源为 archive，解决 buster 拉不到依赖的问题
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y ruby-full build-essential libpq-dev

# 设置工作目录
WORKDIR /app

# 复制 .yarnrc（跳过 engine 检查）
COPY .yarnrc ./

# 复制前端依赖配置文件
COPY package.json yarn.lock ./

# 安装前端依赖
RUN yarn install --ignore-engines

# 复制项目全部文件
COPY . .

# 构建前端（容错处理）
RUN yarn build || yarn webpack

# 安装 Ruby bundler 和 Gem
RUN gem install bundler && bundle install

# 暴露 Rails 默认端口
EXPOSE 3000

# 启动 Rails 应用
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
