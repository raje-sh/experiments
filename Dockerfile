FROM python:alpine

RUN apk add --no-cache --update gcc libc-dev libffi-dev openssl-dev git && \
 git clone https://github.com/r0oth3x49/udemy-dl.git && \
 cd udemy-dl && \
 pip install -r requirements.txt && \
 mkdir -p /course
COPY . ./udemy-dl 

VOLUME ["/course"]
WORKDIR /udemy-dl

ENTRYPOINT ["python", "./udemy-dl.py", "-o", "../course", "-k", "./cookies.txt"]
# CMD sh
