FROM node:alpine
WORKDIR /app
COPY . .
EXPOSE 4200
RUN npm install && ng serve