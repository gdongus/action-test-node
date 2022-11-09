FROM node:14 as build

ENV PATH $PATH:/app/node_modules/.bin
ENV NODE_ENV=production

WORKDIR /app

COPY . .

RUN npm install

RUN npm build /app

FROM node:14-alpine as prod

ENV PATH $PATH:/app/node_modules/.bin
ENV NODE_ENV=production

EXPOSE 3000/tcp

RUN apk add stress-ng

WORKDIR /app

COPY --from=build /app/node_modules node_modules
COPY --from=build /app/build build

ENTRYPOINT ["node", "build/app.js"]