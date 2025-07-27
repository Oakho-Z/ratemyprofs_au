# 使用官方 Node 镜像（版本匹配）
FROM node:12.22.6

# 安装 Ruby 及系统依赖
RUN apt-get update && apt-get install -y ruby-full build-essential libpq-dev

# 设置工作目录
WORKDIR /app

# 拷贝依赖文件
COPY package.json yarn.lock .yarnrc ./

# 安装前端依赖
RUN yarn install --ignore-engines

# 拷贝项目全部文件
COPY . .

# 构建前端（防止 webpack 默认失败）
RUN yarn build || yarn webpack

# 安装 bundler 和 Ruby gem
RUN gem install bundler && bundle install

# 暴露 Rails 默认端口
EXPOSE 3000

# 启动 Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
