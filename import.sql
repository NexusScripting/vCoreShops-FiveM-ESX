CREATE TABLE IF NOT EXISTS `users_tattoos` (
  `identifier` varchar(60) NOT NULL,
  `tattoos` longtext DEFAULT '[]',
  PRIMARY KEY (`identifier`)
);