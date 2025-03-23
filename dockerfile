FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app.py .

# Download and cache EasyOCR models
RUN python -c "import easyocr; reader = easyocr.Reader(['en']); print('EasyOCR models downloaded successfully')"

# Expose the port the app runs on
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]