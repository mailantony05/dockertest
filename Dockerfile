# Define build arguments
ARG BASE_IMAGE
ARG PACKAGE_MANAGER
ARG ADDITIONAL_PACKAGES

# Use the specified base image
FROM ${BASE_IMAGE} AS base

# Install additional packages based on the package manager
RUN if [ "$PACKAGE_MANAGER" = "apt" ]; then \
        apt-get update && \
        apt-get install -y ${ADDITIONAL_PACKAGES}; \
    elif [ "$PACKAGE_MANAGER" = "apk" ]; then \
        apk update && \
        apk add --no-cache ${ADDITIONAL_PACKAGES}; \
    fi

# Java-specific setup
RUN if [ "$BASE_IMAGE" = "openjdk:11-jdk" ]; then \
        # Setup for Java application
        echo "Setting up Java environment"; \
    fi

# Node.js-specific setup
RUN if [ "$BASE_IMAGE" = "node:18" ]; then \
        # Setup for Node.js application
        echo "Setting up Node.js environment"; \
    fi

# Python-specific setup
RUN if [ "$BASE_IMAGE" = "python:3.10" ]; then \
        # Setup for Python application
        echo "Setting up Python environment"; \
    fi

# Copy application code
WORKDIR /app
COPY . .

# Build steps based on the base image
RUN if [ "$BASE_IMAGE" = "openjdk:11-jdk" ]; then \
        mvn clean package; \
    elif [ "$BASE_IMAGE" = "node:18" ]; then \
        npm install; \
    elif [ "$BASE_IMAGE" = "python:3.10" ]; then \
        pip install -r requirements.txt; \
    fi

# Default command based on the base image
CMD ["/bin/bash", "-c", "if [ \"$BASE_IMAGE\" = \"openjdk:11-jdk\" ]; then java -jar target/myapp.jar; elif [ \"$BASE_IMAGE\" = \"node:18\" ]; then node index.js; elif [ \"$BASE_IMAGE\" = \"python:3.10\" ]; then python app.py; fi"]
