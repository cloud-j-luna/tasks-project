FROM node:12.18.2-alpine3.12
WORKDIR /app
COPY . .
EXPOSE 4200
RUN npm install && ng serve