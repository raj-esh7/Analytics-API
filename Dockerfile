#Install Python 3.12.3 on Debian Bullseye Slim
FROM python:3.12.3-slim-bullseye

#Creata a virtual environment
RUN python -m venv /opt/venv

#set up the virtual environment as the current location
ENV PATH="/opt/venv/bin:$PATH"

#install pip and upgrade it
RUN python -m ensurepip && \
    pip install --no-cache --upgrade pip

#setup python related environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Install os dependencies for our mini vm
RUN apt-get update && apt-get install -y \
    # for postgres
    libpq-dev \
    # for Pillow
    libjpeg-dev \
    # for CairoSVG
    libcairo2 \
    # other
    gcc \
    && rm -rf /var/lib/apt/lists/*

#create a mini VM directory
RUN mkdir -p /code
WORKDIR /code

#copy the requirements file into the container
COPY requirements.txt /tmp/requirements.txt

#copy the code into the container
COPY /src .

#install the requirements
RUN pip install --no-cache-dir -r /tmp/requirements.txt

#copy the bash script executable
COPY ./boot/docker-run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

# Clean up apt cache to reduce image size
RUN apt-get remove --purge -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Run the fastapi app
CMD ["/opt/run.sh"]

