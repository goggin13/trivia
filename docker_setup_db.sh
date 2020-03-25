docker exec \                
  trivia-web \         
  bundle exec rake db:create 
                             
docker exec \                
  trivia-web \         
  undle exec rake db:migrate
