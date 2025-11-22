ARG BUILD_FROM
FROM $BUILD_FROM

# Install required packages
RUN \
    apk add --no-cache \
    git \
    nodejs \
    npm

# Set working directory
WORKDIR /app

# Copy run.sh script
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Expose port
EXPOSE 3000

# Start the application
CMD [ "/app/run.sh" ]
