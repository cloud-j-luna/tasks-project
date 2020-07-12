FROM node:alpine
WORKDIR /app
COPY . .
RUN npm install && ng serve