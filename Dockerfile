# 使用官方 Node 镜像（确保版本匹配）
FROM node:12.22.6

# 设置工作目录
WORKDIR /app

# 拷贝依赖清单
COPY package*.json yarn.lock ./

# 安装依赖
RUN yarn install

# 拷贝项目全部文件
COPY . .

# 构建前端
RUN yarn build || yarn webpack

# 安装 Ruby 和依赖（Rails 服务器）
RUN apt-get update && apt-get install -y ruby-full build-essential libpq-dev

# 安装 bundler 和 Rails
RUN gem install bundler && bundle install

# 暴露 Rails 默认端口
EXPOSE 3000

# 启动 rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
