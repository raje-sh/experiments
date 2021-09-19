COURSE_URL	:= https://rakuten-tech.udemy.com/course/socketio-with-websockets-the-details
CWD := $(PWD)
build:
	docker build -t udemy-dl-custom:latest .
start:
	docker run -it --rm -v $(CWD)/courses:/course udemy-dl-custom:latest ${COURSE_URL}
