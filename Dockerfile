FROM python:alpine

RUN apk add --no-cache --update gcc libc-dev libffi-dev openssl-dev git && \
 git clone https://github.com/r0oth3x49/udemy-dl.git && \
 cd udemy-dl && \
 pip install -r requirements.txt && \
 mkdir -p /course 

VOLUME ["/course"]

ENTRYPOINT ["python", "/udemy-dl/udemy-dl.py", "-o", "/course", "-k", "cookies.txt"]