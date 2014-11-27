# Guesser

A dead simple game for 1 or more players made for demonstration purposes. The computer "thinks of" a number and
you're trying to guess it. For each successful guess player gets 1 point.
A player who first gets the specified number of points wins; his statistics is printed to a `txt` file.

For nix systems use

```
bin/guesser
```

to launch the game. For Windows use

```
bin/guesser.bat
```

Available options:

* `-o`, `--points` - how many points should players get to win the game. Should be an integer and cannot be less than 1.
* `-i`, `--limit` - the upper limit for a number to guess (the lower limit is 0). For example, if `5` is provided,
then the generated number will lie in the [0, 5] range. Should be an integer and cannot be less than 1.
* `-p`, `--players` - how many players will participate. Should be an integer and cannot be less than 1.

(c) 2014 [Ilya Bodrov](http://radiant-wind.com)