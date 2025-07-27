# 使用 Ruby + Debian Buster 的稳定镜像
FROM ruby:2.7.8-slim-buster

# 安装 Node.js 12 和 Yarn
RUN apt-get update && apt-get install -y curl gnupg build-essential libpq-dev \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g yarn

# 设置工作目录
WORKDIR /app

# 添加 .yarnrc（忽略 engines 错误）
COPY .yarnrc ./

# 拷贝依赖声明
COPY package.json yarn.lock ./

# 安装 JS 依赖
RUN yarn install --ignore-engines

# 拷贝项目全部文件
COPY . .

# 构建前端（避免 webpack 报错）
RUN yarn build || yarn webpack

# 安装 Ruby 依赖
RUN gem install bundler && bundle install

# 暴露 Rails 默认端口
EXPOSE 3000

# 启动服务器
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
