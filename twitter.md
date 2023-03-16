# twitter

Search for tweets containing a string:

```
select users.screen_name,full_text,tweets.created_at,'https://twitter.com/'||users.screen_name||'/status/'||tweets.id as link from tweets join users on tweets.user = users.id where full_text like '%gitops%';
```

Search for tweets by a user's name:

```
select users.screen_name,full_text,tweets.created_at,'https://twitter.com/'||users.screen_name||'/status/'||tweets.id as link from tweets join users on tweets.user = users.id where screen_name='tweeshan';
```
