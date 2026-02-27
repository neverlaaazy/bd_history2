CREATE DATABASE game_store;

CREATE TABLE IF NOT EXISTS genre(
	genre_id SERIAL NOT NULL,
	name TEXT NOT NULL,
	description TEXT NULL,
	popularity_rating INT NULL,

	CONSTRAINT pk_genre_id PRIMARY KEY(genre_id),
	CONSTRAINT c_genre_popularity_rating CHECK(
		popularity_rating >= 0 AND popularity_rating <= 10 
	)
);

COPY genre
FROM 'E:\import\genres.csv'
WITH(
	DELIMITER ';',
	HEADER true,
	ENCODING 'UTF-8',
	FORMAT CSV
);
SELECT * FROM genre;

CREATE TABLE IF NOT EXISTS game(
	game_id SERIAL NOT NULL,
	title TEXT NOT NULL,
	release_date DATE,
	price DECIMAL(10, 2),
	description TEXT,
	genre_id INT,

	CONSTRAINT pk_game_id PRIMARY KEY(game_id),
	CONSTRAINT c_game_price CHECK(price >= 0),
	CONSTRAINT fk_game_genre_id FOREIGN KEY(genre_id)
		REFERENCES genre(genre_id)
		ON UPDATE CASCADE ON DELETE SET NULL
);

COPY game
FROM 'E:\import\games.csv'
WITH(
	DELIMITER ';',
	FORMAT CSV,
	HEADER true,
	ENCODING 'UTF-8'
);
SELECT * FROM game;


CREATE TABLE IF NOT EXISTS player(
	player_id SERIAL NOT NULL,
	username TEXT NOT NULL,
	email TEXT,
	registration_date DATE,
	country TEXT,

	CONSTRAINT pk_player_id PRIMARY KEY(player_id)
);

COPY player
FROM 'E:\import\players.csv'
WITH(
	FORMAT CSV,
	DELIMITER ';',
	ENCODING 'UTF-8',
	HEADER true
);
SELECT * FROM player;

CREATE TABLE IF NOT EXISTS purchase(
	purchase_id SERIAL NOT NULL,
	player_id INT,
	game_id INT,
	purchase_date DATE,
	purchase_price DECIMAL(10, 2),

	CONSTRAINT pk_purchase_id PRIMARY KEY(purchase_id),
	CONSTRAINT fk_purchase_player FOREIGN KEY(player_id)
		REFERENCES player(player_id)
		ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_purchase_game FOREIGN KEY(game_id)
		REFERENCES game(game_id)
		ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT c_purchase_price CHECK(purchase_price >= 0)
);

COPY purchase
FROM 'E:\import\purchases.csv'
WITH(
	FORMAT CSV,
	DELIMITER ';',
	HEADER true,
	ENCODING 'UTF-8'
);

