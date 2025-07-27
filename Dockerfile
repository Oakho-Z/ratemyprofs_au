# 使用官方 Node.js 12 镜像（带 Debian Buster，稳定）
FROM node:12.22.6-buster

# 安装 Ruby 和构建相关依赖
RUN apt-get update && apt-get install -y \
  ruby-full \
  build-essential \
  libpq-dev

# 设置工作目录
WORKDIR /app

# 复制 Yarn 配置（跳过 engine 检查）
COPY .yarnrc ./

# 拷贝依赖清单
COPY package.json yarn.lock ./

# 安装前端依赖
RUN yarn install --ignore-engines

# 拷贝项目文件
COPY . .

# 构建前端（webpack 容错）
RUN yarn build || yarn webpack

# 安装 bundler 和 Ruby gem
RUN gem install bundler && bundle install

# 暴露 Rails 默认端口
EXPOSE 3000

# 启动 Rails 服务器
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
