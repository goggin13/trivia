if docker ps | grep -o trivia-web ; then
  docker exec -it trivia-web bash
else
	docker run \
		-it \
		--name trivia-console \
		-v $HOME/Documents/projects/trivia:/var/www/trivia \
		--rm \
		goggin13/trivia \
		bash
fi
