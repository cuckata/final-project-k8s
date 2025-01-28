FROM node:16

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY app.js /app/
COPY public /app/public/
COPY smoke.sh /app/smoke.sh

EXPOSE 3000

CMD ["node", "app.js"]