build:
	docker build -t udemy-dl-custom:latest .
start:
	COURSE_URL=https://rakuten-tech.udemy.com/course/socketio-with-websockets-the-details
	docker run -it --rm -v $(pwd)/courses:/course udemy-dl-custom:latest "$URL_COURSE"
