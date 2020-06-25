# 1st stage build client
FROM node:latest as builder
# copy package-lock.json (mainly) and package.json
ADD package.json .

ADD package-lock.json .
# npm ci for better performance in dependency resolution
RUN npm ci
# bundle client
ADD . .
# build with webpack
RUN npm run build

# 2nd stage: lightweight alpine container
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN nginx -t

COPY --from=builder /dist /usr/share/nginx/html/