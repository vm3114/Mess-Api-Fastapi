# FROM ubuntu:bionic
FROM python:3.10

RUN apt-get update && apt-get install -y \
    # python3 python3-pip \
    fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libnspr4 libnss3 lsb-release xdg-utils libxss1 libdbus-glib-1-2 \
    curl unzip wget vim \
    xvfb libgbm1 libu2f-udev libvulkan1

RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/bin && \
    chmod +x /usr/bin/chromedriver && \
    rm chromedriver_linux64.zip

RUN CHROME_SETUP=google-chrome.deb && \
    wget -O $CHROME_SETUP "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" && \
    dpkg -i $CHROME_SETUP && \
    # apt install $CHROME_SETUP && \
    apt-get install -y -f && \
    rm $CHROME_SETUP

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV PATH="$PATH:/bin:/usr/bin"

# RUN pip3 install pyvirtualdisplay
# RUN pip3 install Selenium-Screenshot
WORKDIR /app

# COPY requirements.txt /app

COPY . /app

RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

# ENTRYPOINT ["python3"]
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "10000"]

# ENV APP_HOME /usr/src/app
# WORKDIR /$APP_HOME

# COPY . $APP_HOME/

# CMD tail -f /dev/null
# CMD python3 app.py