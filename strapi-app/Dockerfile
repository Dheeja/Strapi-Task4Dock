# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app
COPY . .



# Build Strapi Admin Panel
RUN npm run build

# Expose default Strapi port
EXPOSE 1337

# Start Strapi
CMD ["npm", "run", "start"]
