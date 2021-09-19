COURSE_URL	:= 
CWD := $(PWD)
build:
	docker build -t udemy-dl-custom:latest .
start:
	docker run -it --rm -v $(CWD)/courses:/course udemy-dl-custom:latest ${COURSE_URL}
