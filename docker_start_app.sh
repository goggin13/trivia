# docker run \
#   --name trivia-web \
#   -v $HOME/Documents/projects/trivia:/var/www/trivia \
#   --rm \
#   goggin13/trivia

docker run \
  -it \
  -p 3000:3000 \
  --name trivia-web \
  -v $HOME/Documents/projects/trivia:/var/www/trivia \
  --rm \
  goggin13/trivia \
  bash
