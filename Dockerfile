ARG FUNCTION_DIR=/var/task

FROM xxxxxx.dkr.ecr.us-east-1.amazonaws.com/ubuntu20.04-python3.8-base:latest

WORKDIR /var/task

ENV STORE_TYPE=s3
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata
ENV TESSERACT_PATH=/usr/bin/tesseract
ENV ZBAR_PATH=libzbar.so
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
ENV AWS_ACCESS_KEY_ID=xxxxxxxxx
ENV AWS_SECRET_ACCESS_KEY=xxxxxxxxxx

# Install the function's dependencies
RUN apt-get update
RUN apt-get install -y tesseract-ocr libzbar0 libdmtx0b build-essential libgl1-mesa-dev

RUN pip install awslambdaric

# Copy source into lambda context path
COPY . ${FUNCTION_DIR}

RUN pip install -r requirements.txt

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "main.handler" ]
