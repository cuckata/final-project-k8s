FROM node:16

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY app.js /app/
COPY public /app/public/

EXPOSE 3000

CMD ["node", "app.js"]