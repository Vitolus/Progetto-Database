BEGIN;
DROP TABLE IF EXISTS Utente CASCADE;
DROP TABLE IF EXISTS Indirizzo CASCADE;
DROP TABLE IF EXISTS Carta_di_credito CASCADE;
DROP TABLE IF EXISTS Possesso CASCADE;
DROP TABLE IF EXISTS Ordine CASCADE;
DROP TABLE IF EXISTS Accessorio CASCADE;
DROP TABLE IF EXISTS OrdineA CASCADE;
DROP TABLE IF EXISTS Regolamento CASCADE;
DROP TABLE IF EXISTS Avventura CASCADE;
DROP TABLE IF EXISTS OrdineR CASCADE;
DROP TABLE IF EXISTS OrdineT CASCADE;
DROP TABLE IF EXISTS Razza CASCADE;
DROP TABLE IF EXISTS Descrizione CASCADE;
DROP TABLE IF EXISTS Classe CASCADE;
DROP TABLE IF EXISTS Regolazione CASCADE;
DROP TABLE IF EXISTS Incantesimo CASCADE;
DROP TABLE IF EXISTS Magia CASCADE;
DROP TABLE IF EXISTS Personaggio CASCADE;

CREATE TABLE Utente(
    mail character varying(50) PRIMARY KEY,
    nome character varying(50) NOT NULL,
    cognome character varying(50) NOT NULL,
    password character varying(30) NOT NULL,
    telefono character varying(20)
);

CREATE TABLE Indirizzo(
    ID SERIAL PRIMARY KEY,
    utente character varying(50) NOT NULL,
    via character varying(50) NOT NULL,
    N_civico character varying(5) NOT NULL,
    CAP character(5) NOT NULL,
    citta character varying(50) NOT NULL,
    stato character varying(50) NOT NULL
);

CREATE TABLE Carta_di_credito(
    numero character(16) PRIMARY KEY,
    circuito character varying(20) NOT NULL,
    scadenza date NOT NULL,
    intestatario character varying(50) NOT NULL
);

CREATE TABLE Possesso(
    utente character varying(50) NOT NULL,
    carta character(16) NOT NULL
);

CREATE TABLE Ordine(
    ID SERIAL PRIMARY KEY,
    importo real NOT NULL,
    dataPagamento date NOT NULL,
    indirizzo integer NOT NULL,
    carta character(16) NOT NULL,
    utente character varying(50) NOT NULL
);

DROP TYPE IF EXISTS material;
CREATE TYPE material AS ENUM ('polimeri', 'metallo', 'legno');
CREATE TABLE Accessorio(
    ID SERIAL PRIMARY KEY,
    nome character varying(50) NOT NULL,
    tipo character varying(50) NOT NULL,
    prezzo real NOT NULL,
    colore character varying(20),
    materiale mataterial,
    tema character varying(30)
);

CREATE TABLE OrdineA(
    ordine integer NOT NULL,
    accessorio integer NOT NULL
);

CREATE TABLE Regolamento(
    nome character varying(50) PRIMARY KEY,
    dataPubblicazione date,
    prezzo real NOT NULL
);

CREATE TABLE Avventura(
    nome character varying(50) PRIMARY KEY,
    dataPubblicazione date,
    prezzo real NOT NULL,
    capitoli integer NOT NULL DEFAULT 1
);

CREATE TABLE OrdineR(
    ordine SERIAL,
    regolamento character varying(50) NOT NULL
);

CREATE TABLE OrdineT(
    ordine SERIAL,
    avventura character varying(50) NOT NULL
);

DROP TYPE IF EXISTS tagli;
CREATE TYPE tagli AS ENUM ('media', 'piccola');
CREATE TABLE Razza(
    nome character varying(50) PRIMARY KEY,
    taglia tagli NOT NULL,
    lingua character varying(50) NOT NULL
);

CREATE TABLE Descrizione(
    razza character varying(50) NOT NULL,
    avventura character varying(50) NOT NULL,
);

DROP TYPE ID EXISTS origin;
CREATE TYPE origin AS ENUM ('marziale', 'arcana', 'divina');
DROP TYPE ID EXISTS attribut;
CREATE TYPE attribut AS ENUM ('forza', 'destrezza', 'intelligenza', 'saggezza', 'carisma');
CREATE TABLE Classe(
    nome character varying(50) PRIMARY KEY,
    origine spec NOT NULL,
    attributo car NOT NULL
);

CREATE TABLE Regolazione(
    classe character varying(50) NOT NULL,
    regolamento character varying(50) NOT NULL,
);

DROP TYPE ID EXISTS scuol;
CREATE TYPE scuol AS ENUM ('abiurazione', 'ammaliamento', 'divinazione', 'evocazione', 'illusionee', 'invocazione', 'necromanzia', 'trasmutazione');
CREATE TABLE Incantesimo(
    nome character varying(50) PRIMARY KEY,
    livello integer NOT NULL CHECK (livello <= 9) DEFAULT 0,
    scuola scuol NOT NULL
);

CREATE TABLE Magia(
    classe character varying(50),
    incantesimo character varying(50)
);

CREATE TABLE Personaggio(
    "ID" SERIAL PRIMARY KEY,
    nome character varying(50) NOT NULL,
    livello integer NOT NULL DEFAULT 1,
    razza character varying(50) NOT NULL,
    classe character varying(50) NOT NULL,
    utente character varying(50) NOT NULL,
);

ALTER TABLE IF EXISTS Indirizzo
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Possesso
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Possesso
    ADD FOREIGN KEY (carta)
    REFERENCES Carta_di_credito (numero) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Ordine
    ADD FOREIGN KEY (indirizzo)
    REFERENCES Indirizzo (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Ordine
    ADD FOREIGN KEY (carta)
    REFERENCES Carta_di_credito (numero) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Ordine
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineA
    ADD FOREIGN KEY (ordine)
    REFERENCES Ordine (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineA
    ADD FOREIGN KEY (accessorio)
    REFERENCES Accessorio (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineR
    ADD FOREIGN KEY (ordine)
    REFERENCES Ordine (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineR
    ADD FOREIGN KEY (regolamento)
    REFERENCES Regolamento (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS OrdineT
    ADD FOREIGN KEY (ordine)
    REFERENCES Ordine (ID) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS OrdineT
    ADD FOREIGN KEY (avventura)
    REFERENCES Avventura (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS Descrizione
    ADD FOREIGN KEY (razza)
    REFERENCES Razza (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Descrizione
    ADD FOREIGN KEY (avventura)
    REFERENCES Avventura (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS Regolazione
    ADD FOREIGN KEY (classe)
    REFERENCES Classe (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Regolazione
    ADD FOREIGN KEY (regolamento)
    REFERENCES Regolamento (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS Magia
    ADD FOREIGN KEY (classe)
    REFERENCES Classe (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Magia
    ADD FOREIGN KEY (incantesimo)
    REFERENCES Incantesimo (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Personaggio
    ADD FOREIGN KEY (razza)
    REFERENCES Razza (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Personaggio
    ADD FOREIGN KEY (classe)
    REFERENCES Classe (nome) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS Personaggio
    ADD FOREIGN KEY (utente)
    REFERENCES Utente (mail) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

INSERT INTO Utente(mail, nome, cognome, password, telefono) VALUES
('kev@gmail.com','Kevin','Gallo','password','0123456789'),
('dav0@gmail.com','Davide','Bertolin','pessword','9876543210'),
('and99@gmail.com','Andrea','Barozzi','pissword','7894561230'),
('laura@gmail.com','Laura','Milanesi','possword','0321654987'),
('ste@gmail.com','Stefano','Mura','pussword','7410852096'),
('m4att@gmail.com','Matteo','Torre','teoPazzo' ,'7539518426'),
('nanna@gmail.com','Anna','Battois','agnello'),
('bea00@gmail.com','Beatrice','Lachin','traditrice'),
('dany@gmail.com','Daniele','Vannuccini','agagag4'),
('imlis@gmail.com','Lisa','De Grandis','NeVeR','1749800286');

INSERT INTO Indirizzo(ID, utente, via, N_civico, CAP, citta, stato) VALUES --aggiungere tuple
('1', 'kev@gmail.com','via Milano','45','30100','Mestre','Italy'),
('2', 'dav0@gmail.com','via G. Favretto','40','30174','Zelarino','Italy');

INSERT INTO Carta_di_credito(numero, circuito, scadenza, intestatario) VALUES --aggiungere tuple
('0123456789876543','visa','2023-12-30','Kevin Gallo'),
('9876543210123456','visa','2024-04-15','Davide Bertolin');

INSERT INTO Possesso(utente, carta) VALUES -- aggiungere tuple
('kev@gmail.com','0123456789876543'),
('dav0@gmail.com','9876543210123456');

INSERT INTO Ordine(ID, importo, dataPagamento, indirizzo, carta, utente) VALUES --completare tuple
('1','7.96','2014-11-30','','','m4att@gmail.com',),
('2','59.98','2014-11-30','2','9876543210123456','dav0@gmail.com'),
('3','29.99','2014-12-21','2','9876543210123456','dav0@gmail.com'),
('4','83.94','2015-04-16','1','0123456789876543','kev@gmail.com'),
('5','39.98','2016-08-26','','','imlis@gmail.com'),
('6','84.97','2016-11-30','','','ste@gmail.com'),
('7','15.99','2017-04-19','','','m4att@gmail.com'),
('8','149.95','2018-12-25','','','laura@gmail.com'),
('9','119.96','2020-09-22','2','9876543210123456','dav0@gmail.com'),
('10','89.97','2020-11-17','','','dany@gmail.com'),
('11','89.97','2021-12-08','','','m4att@gmail.com'),
('12','54.98','2021-12-25','1','0123456789876543','kev@gmail.com');

INSERT INTO Accessorio(ID, nome, tipo, prezzo, colore, materiale, tema) VALUES
('1','Pigment','dado','7.96','verde','polimeri',''),
('2','Pigment','dado','7.96','rosso','polimeri',''),
('3','Pigment','dado','7.96','giallo','polimeri',''),
('4','Elder heart','dado','5.99','verde','polimeri',''),
('5','Call of the corrupted','dado','7.96','bianco','polimeri',''),
('6','Enlightenment','dado','20.84','chiaro','legno',''),
('7','Battle for beyond','dado','23.96','scuro','legno',''),
('8','Blacksmith','dado','30.55','bronzo','metallo',''),
('9','Blacksmith','dado','30.55','oro','metallo',''),
('10','Blacksmith','dado','30.55','argento','metallo',''),
('11','Miniera di cristalli','mappa','12.99','','','miniera'),
('12','Villaggio di Phandalver','mappa','15.99','','','villaggio'),
('13','Cripta del lich','mappa','11.99','','','dungeon'),
('14','Catacombe di sabbia','mappa','12.99','','','dungeon');

INSERT INTO OrdineA(ordine, accessorio) VALUES
('1','1'),
('4','7'),
('7','12');

INSERT INTO  Regolamento(nome, dataPubblicazione, prezzo) VALUES
(E'Player\'s Handbook','2014-08-19','29.99'),
('Monster Manual','2014-09-30','29.99'),
(E'Dungeon Master\'s Guide','2014-12-09','29.99'),
(E'Sword Coast Adventure\'s Guide','2015-11-3','29.99'),
(E'Volo\'s Guide to Monsters','2016-11-15','29.99'),
(E'Xanathar\'s Guide to Everything','2017-11-21','29.99'),
(E'Mordenkainen\'s Tome of Foes','2018-05-29','29.99'),
(E'Guildmasters\'s Guide to Ravnica','2018-11-20','29.99'),
('Acquisitions Incorporated','2019-06-18','29.99'),
('Eberron: Rising form the Last War','2019-11-19','29.99'),
(E'Explorer\'s Guide to Wildemount','2020-03-17','29.99'),
('Mythic Odysseys of Theros','2020-06-02','29.99'),
(E'Tasha\'s Cauldron of Everything','2020-11-17','29.99'),
(E'Van Richten\'s Guide to Ravenloft','2021-05-18','29.99'),
(E'Fizban\'s Treasury of Dragons','2021-10-26','29.99'),
('Strixhaven: A Curriculum of Chaos','2021-12-07','29.99');

INSERT INTO  Avventura(nome, dataPubblicazione, prezzo, capitoli) VALUES
('Hoard of the Dragon Queen','2014-08-19','19.99','8'),
('Rise of Tiamat','2014-11-04','19.99','9'),
('Princes of the Apocalypse','2015-04-07','24.99','7'),
('Out of the Abyss','2015-09-15','29.99','17'),
('Curse of Strahd','2016-03-15','24.99','15'),
(E'Storn King\'s Thunder','2016-09-06','24.99','12'),
('Tomb of Annihilation','2017-09-19','24.99','5'),
('Waterdeep: Dragon Heist','2018-09-18','29.99','9'),
('Waterdeep: Dungeon of the Mad Mage','2018-11-13','29.99','23'),
('Ghosts of Saltmarsh','2019-05-21','29.99','8'),
(E'Baldur\'s Gate: Descent Into Avernus','2019-09-18','29.99','5'),
('Icewind Dale: Rime of the Frostmaiden','2020-09-15','29.99','7'),
('Candlekeep Mysteries','2021-03-16','29.99','17'),
('The Wild Beyond the Witchlight','2021-09-21','29.99','5');

INSERT INTO OrdineR(ordine, regolamento) VALUES
('2',E'Dungeon Master\'s Guide'),
('2','Monster Manual'),
('3',E'Player\'s Handbook'),
('4','Monster Manual'),
('4',E'Dungeon Master\'s Guide'),
('6',E'Sword Coast Adventure\'s Guide'),
('6',E'Volo\'s Guide to Monsters'),
('8',E'Player\'s Handbook'),
('8',E'Xanathar\'s Guide to Everything'),
('8',E'Mordenkainen\'s Tome of Foes'),
('9',E'Mordenkainen\'s Tome of Foes'),
('9',E'Explorer\'s Guide to Wildemount'),
('9',E'Guildmasters\'s Guide to Ravnica'),
('10','Mythic Odysseys of Theros'),
('11',E'Tasha\'s Cauldron of Everything'),
('11','Strixhaven: A Curriculum of Chaos'),
('11',E'Van Richten\'s Guide to Ravenloft'),
('12',E'Fizban\'s Treasury of Dragons');

INSERT INTO OrdineT(ordine, avventura) VALUES
('5','Hoard of the Dragon Queen'),
('5','Rise of Tiamat'),
('6','Curse of Strahd'),
('8','Waterdeep: Dragon Heist'),
('8','Waterdeep: Dungeon of the Mad Mage'),
('9','Ghosts of Saltmarsh'),
('10',E'Baldur\'s Gate: Descent Into Avernus'),
('10','Icewind Dale: Rime of the Frostmaiden'),
('12',E'Storn King\'s Thunder');

INSERT INTO Razze(nome, taglia, lingua) VALUES
('Arakocra','media','primordiale','DMG'),
('Aasimar','media','celestiale','DMG'),
('Bugbear','media','goblin','VGM'),
('Centaur','media','silvano','GGR'),
('Changeling','media','comune','ERLW'),
('Dhampir','media','comune','VRGR'),
('Dragonborn','media','draconico','PHB'),
('Dwarf','media','nanico','PHB'),
('Duergar','media','nanico','MTF'),
('Elf','media','elfico','PHB'),
('Drow','media','elfico','PHB'),
('Eladrin','media','elfico','MTF'),
('Firbolg','media','elfico','VGM'),
('Genasi','media','primordiale','DMG'),
('Gith','media','gith','MTF'),
('Gnome','piccola','gnomico','PHB'),
('Svirfneblin','piccola','gnomico','SCAG'),
('Goblin','piccola','goblin','VGM'),
('Goliath','media','gigante','VGM'),
('Half-Elf','media','elfico','PHB'),
('Half-Orc','media','orchesco','PHB'),
('Halfling','media','elfico','PHB'),
('Hexblood','media','comune','VRGR'),
('Hobgoblin','media','goblin','VGM'),
('Human','media','comune','PHB'),
('Kalashtar','media','Quori','ERLW'),
('Kenku','media','primordiale','VGM'),
('Kobold','piccola','draconico','VGM'),
('Leonin','media','leonin','MOT'),
('Lizardfolk','media','draconico','VGM'),
('Loxodon','media','loxodon','GGR'),
('Minotaur','media','Minotaur','GGR'),
('Orc','media','orchesco','VGM'),
('Owlin','media','primordiale','SCC'),
('Reborn','media','comune','VRGR'),
('Satyr','media','silvano','MOT'),
('Shifter','media','comune','ERLW'),
('Simic Hybrid','media','vedalken','GGR'),
('Tabaxi','media','comune','VGM'),
('Tiefling','media','infernale','PHB'),
('Triton','media','primordiale','VGM'),
('Vedalken','media','vedalken','GGR'),
('Verdan','piccola','goblin','AI'),
('Warforged','media','comune','ERLW'),
('Yuan-ti Pureblood','media','abissale','VGM');

INSERT INTO Descrizione(razza, avventura) VALUES
('Arakocra','Princes of the Apocalypse'),
('Arakocra',E'Storn King\'s Thunder'),
('Aasimar','Princes of the Apocalypse'),
('Centaur','The Wild Beyond the Witchlight'),
('Dhampir','Tomb of Annihilation'),
('Dhampir','Curse of Strahd'),
('Dragonborn','Hoard of the Dragon Queen'),
('Dragonborn','Rise of Tiamat'),
('Duergar','Waterdeep: Dragon Heist'),
('Duergar','Waterdeep: Dungeon of the Mad Mage'),
('Drow','Out of the Abyss'),
('Eladrin','The Wild Beyond the Witchlight'),
('Firbolg','The Wild Beyond the Witchlight'),
('Genasi','Princes of the Apocalypse'),
('Genasi',E'Storn King\'s Thunder'),
('Gith','Candlekeep Mysteries'),
('Svirfneblin','Out of the Abyss'),
('Goliath',E'Storn King\'s Thunder'),
('Hexblood','Curse of Strahd'),
('Hexblood','The Wild Beyond the Witchlight'),
('Hobgoblin','Ghosts of Saltmarsh'),
('Kalashtar','Icewind Dale: Rime of the Frostmaiden'),
('Kobold','Rise of Tiamat'),
('Lizardfolk','Tomb of Annihilation'),
('Lizardfolk','Ghosts of Saltmarsh'),
('Minotaur','The Wild Beyond the Witchlight'),
('Owlin','Candlekeep Mysteries'),
('Owlin','Icewind Dale: Rime of the Frostmaiden'),
('Reborn','Curse of Strahd'),
('Satyr','The Wild Beyond the Witchlight'),
('Shifter','The Wild Beyond the Witchlight'),
('Shifter',E'Baldur\'s Gate: Descent Into Avernus'),
('Tabaxi','Tomb of Annihilation'),
('Tiefling','E'Baldur\'s Gate: Descent Into Avernus'),
('Triton','Ghosts of Saltmarsh'),
('Triton','Princes of the Apocalypse'),
('Warforged','Candlekeep Mysteries'),
('Yuan-ti Pureblood','Tomb of Annihilation');

INSERT INTO Classe(nome, origine, attributo) VALUES
('Artificer','arcana','intelligenza'),
('Barbarian','marziale','forza'),
('Bard','arcana','carisma'),
('Cleric','divina','saggezza'),
('Druid','arcana','saggezzza'),
('Fighter','marziale','forza'),
('Monk','marziale','destrezza'),
('Paladin','divina','forza'),
('Ranger','arcana','destrezza'),
('Rogue','marziale','destrezza'),
('Sorcerer','arcana','carisma'),
('Warlock','arcana','carisma'),
('Wizard','arcana','intelligenza');

INSERT INTO Regolazione(classe, regolamento) VALUES
('Barbarian',E'Player\'s Handbook'),
('Bard',E'Player\'s Handbook'),
('Cleric',E'Player\'s Handbook'),
('Druid',E'Player\'s Handbook'),
('Fighter',E'Player\'s Handbook'),
('Monk',E'Player\'s Handbook'),
('Paladin',E'Player\'s Handbook'),
('Ranger',E'Player\'s Handbook'),
('Rogue',E'Player\'s Handbook'),
('Sorcerer',E'Player\'s Handbook'),
('Warlock',E'Player\'s Handbook'),
('Wizard',E'Player\'s Handbook'),
('Artificer',E'Tasha\'s Cauldron of Everything'),
('Artificer',E'Guildmasters\'s Guide to Ravnica'),
('Barbarian',E'Volo\'s Guide to Monsters'),
('Bard',E'Sword Coast Adventure\'s Guide'),
('Cleric',E'Sword Coast Adventure\'s Guide'),
('Druid','Mythic Odysseys of Theros'),
('Paladin',E'Guildmasters\'s Guide to Ravnica'),
('Rogue',E'Xanathar\'s Guide to Everything'),
('Sorcerer','Strixhaven: A Curriculum of Chaos'),
('Warlock','Strixhaven: A Curriculum of Chaos'),
('Wizard','Strixhaven: A Curriculum of Chaos');

INSERT INTO Incantesimo(nome, livello, scuola) VALUES
('Booming Blade','0','evocazione'),
('Chill Touch','0','necromanzia'),
('Druidcraft','0','trasmutazione'),
('Eldritch Blast','0','evocazione'),
('Fire Bolt','0','evocazione'),
('Guidance','0','divinazione'),
('Light','0','evocazione'),
('Mage Hand','0','invocazione'),
('Mending','0','trasmutazione'),
('Mind Sliver','0','ammaliamento'),
('Minor illusion','0','illusione'),
('Prestidigitation','0','invocazione'),
('Ray of Frost','0','evocazione'),
('Resistance','0','abiurazione'),
('Sacred Flame','0','evocazione'),
('Vicious Mockery','0','ammaliamento'),
('Absorb Elements','1','abiurazione'),
('Arms of Hadar','1','invocazione'),
('Catapult','1','trasmutazione'),
('Cause Fear','1','necromanzia'),
('Chaos Bolt','1','evocazione'),
('Charm Person','1','ammaliamento'),
('Comprehend Languages','1','divinazione'),
('Cure Wounds','1','evocazione'),
('Detect Magic','1','divinazione'),
('Disguise Self','1','illusione'),
('Dissonant Whispers','1','ammaliamento'),
('Find Familiar','1','invocazione'),
('Magic Missile','1','evocazione'),
('Shield','1','abiurazione'),
('Alter Self','2','trasmutazione'),
('Blindness/Deafness','2','necromanzia'),
('Darkness','2','evocazione'),
('Detect Thoughts','2','divinazione'),
('Healing Spirit','2','invocazione'),
('Invisibility','2','illusione'),
('Misty Step','2','invocazione'),
('Shatter','2','evocazione'),
('Suggestion','2','ammaliamento'),
('Animate Dead','3','necromanzia'),
('Blink','3','trasmutazione'),
('Counterspell','3','abiurazione'),
('Dispel Magic','3','abiurazione'),
('Fireball','3','evocazione'),
('Vampiric Touch','3','necromanzia'),
('Wall of Water','3','evocazione'),
('Banishment','4','abiurazione'),
('Confusion','4','ammaliamento'),
('Death Ward','4','abiurazione'),
('Divinazione','4','divinazione'),
('Phantasmal Killer','4','illusione'),
('Polymorph','4','trasmutazione'),
('Storm Sphere','4','evocazione'),
('Circle of Power','5','abiurazione'),
('Cone of Cold','5','evocazione'),
('Creation','5','illusione'),
('Far Step','5','invocazione'),
('Hold Monster','5','ammaliamento'),
('Raise Dead','5','necromanzia'),
('Wrath of Nature','5','evocazione'),
('Druid Grove','6','abiurazione'),
('Mental Prison','6','illusione'),
('True Seeing','6','divinazione'),
('Divine Word','7','evocazione'),
('Etherealness','7','trasmutazione'),
('Plane Shift','7','invocazione'),
('Power Word Pain','7','ammaliamento'),
('Resurrection','7','necromanzia'),
('Antimagic Field','8','abiurazione'),
('Holy Aura','8','abiurazione'),
('Maze','8','invocazione'),
('Illusory Dragon','8','illusione'),
('Mighty Fortress','8','invocazione'),
('Astral Projection','9','necromanzia'),
('Blade of Disaster','9','invocazione'),
('Gate','9','invocazione'),
('Meteor Swarm','9','evocazione'),
('True Resurrection','9','necromanzia');

INSERT INTO Magia(classe, incantesimo) VALUES
('Booming Blade','Sorcerer'),
('Booming Blade','Warlock'),
('Booming Blade','Wizard'),
('Booming Blade','Artificer'),
('Chill Touch','Sorcerer'),
('Chill Touch','Warlock'),
('Chill Touch','Wizard'),
('Druidcraft','Druid'),
('Eldritch Blast','Warlock'),
('Fire Bolt','Sorcerer'),
('Fire Bolt','Wizard'),
('Fire Bolt','Artificer'),
('Guidance','Cleric'),
('Guidance','Druid'),
('Guidance','Artificer'),
('Light','Bard'),
('Light','Cleric'),
('Light','Sorcerer'),
('Light','Wizard'),
('Light','Artificer'),
('Mage Hand','Bard'),
('Mage Hand','Wizard'),
('Mage Hand','Sorcerer'),
('Mage Hand','Warlock'),
('Mage Hand','Artificer'),
('Mending','Artificer'),
('Mending','Bard'),
('Mending','Cleric'),
('Mending','Druid'),
('Mending','Sorcerer'),
('Mending','Wizard'),
('Mind Sliver','Sorcerer'),
('Mind Sliver','Warlock'),
('Mind Sliver','Wizard'),
('Minor illusion','Bard'),
('Minor illusion','Sorcerer'),
('Minor illusion','Warlock'),
('Minor illusion','Wizard'),
('Prestidigitation','Bard'),
('Prestidigitation','Cleric'),
('Prestidigitation','Sorcerer'),
('Prestidigitation','Wizard'),
('Prestidigitation','Artificer'),
('Ray of Frost','Sorcerer'),
('Ray of Frost','Wizard'),
('Ray of Frost','Artificer'),
('Resistance','Cleric'),
('Resistance','Druid'),
('Resistance','Artificer'),
('Sacred Flame','Cleric'),
('Vicious Mockery','Bard'),
('Absorb Elements','Druid'),
('Absorb Elements','Ranger'),
('Absorb Elements','Sorcerer'),
('Absorb Elements','Wizard'),
('Absorb Elements','Artificer'),
('Arms of Hadar','Warlock'),
('Catapult','Sorcerer'),
('Catapult','Wizard'),
('Catapult','Artificer'),
('Cause Fear','Warlock'),
('Cause Fear','Wizard'),
('Chaos Bolt','Sorcerer'),
('Charm Person','Bard'),
('Charm Person','Druid'),
('Charm Person','Sorcerer'),
('Charm Person','Warlock'),
('Charm Person','Wizard'),
('Comprehend Languages','Bard'),
('Comprehend Languages','Sorcerer'),
('Comprehend Languages','Warlock'),
('Comprehend Languages','Wizard'),
('Cure Wounds','Bard'),
('Cure Wounds','Cleric'),
('Cure Wounds','Druid'),
('Cure Wounds','Paladin'),
('Cure Wounds','Ranger'),
('Cure Wounds','Artificer'),
('Detect Magic','Bard'),
('Detect Magic','Cleric'),
('Detect Magic','Druid'),
('Detect Magic','Paladin'),
('Detect Magic','Ranger'),
('Detect Magic','Sorcerer'),
('Detect Magic','Wizard'),
('Detect Magic','Artificer'),
('Disguise Self','Bard'),
('Disguise Self','Sorcerer'),
('Disguise Self','Artificer'),
('Disguise Self','Wizard'),
('Dissonant Whispers','Bard'),
('Find Familiar','Wizard'),
('Magic Missile','Sorcerer'),
('Magic Missile','Wizard'),
('Shield','Sorcerer'),
('Shield','Wizard'),
('Alter Self','Sorcerer'),
('Alter Self','Wizard'),
('Alter Self','Artificer'),
('Blindness/Deafness','Bard'),
('Blindness/Deafness','Cleric'),
('Blindness/Deafness','Sorcerer'),
('Blindness/Deafness','Wizard'),
('Darkness','Cleric'),
('Darkness','Sorcerer'),
('Darkness','Wizard'),
('Detect Thoughts','Bard'),
('Detect Thoughts','Wizard'),
('Detect Thoughts','Sorcerer'),
('Healing Spirit','Druid'),
('Healing Spirit','Ranger'),
('Invisibility','Bard'),
('Invisibility','Wizard'),
('Invisibility','Sorcerer'),
('Invisibility','Warlock'),
('Invisibility','Artificer'),
('Misty Step','Sorcerer'),
('Misty Step','Warlock'),
('Misty Step','Wizard'),
('Shatter','Bard'),
('Shatter','Wizard'),
('Shatter','Sorcerer'),
('Shatter','Warlock'),
('Suggestion','Bard'),
('Suggestion','Wizard'),
('Suggestion','Sorcerer'),
('Suggestion','Warlock'),
('Animate Dead','Cleric'),
('Animate Dead','Wizard'),
('Blink','Sorcerer'),
('Blink','Wizard'),
('Blink','Artificer'),
('Counterspell','Wizard'),
('Counterspell','Sorcerer'),
('Counterspell','Warlock'),
('Dispel Magic','Bard'),
('Dispel Magic','Cleric'),
('Dispel Magic','Druid'),
('Dispel Magic','Paladin'),
('Dispel Magic','Sorcerer'),
('Dispel Magic','Warlock'),
('Dispel Magic','Wizard'),
('Dispel Magic','Artificer'),
('Fireball','Sorcerer'),
('Fireball','Wizard'),
('Vampiric Touch','Warlock'),
('Vampiric Touch','Wizard'),
('Wall of Water','Druid'),
('Wall of Water','Sorcerer'),
('Wall of Water','Wizard'),
('Banishment','Cleric'),
('Banishment','Paladin'),
('Banishment','Sorcerer'),
('Banishment','Warlock'),
('Banishment','Wizard'),
('Confusion','Bard'),
('Confusion','Druid'),
('Confusion','Sorcerer'),
('Confusion','Wizard'),
('Death Ward','Cleric'),
('Death Ward','Paladin'),
('Divinazione','Cleric'),
('Phantasmal Killer','Wizard'),
('Polymorph','Bard'),
('Polymorph','Druid'),
('Polymorph','Sorcerer'),
('Polymorph','Wizard'),
('Storm Sphere','Sorcerer'),
('Storm Sphere','Wizard'),
('Circle of Power','Paladin'),
('Cone of Cold','Sorcerer'),
('Cone of Cold','Wizard'),
('Creation','Sorcerer'),
('Creation','Wizard'),
('Creation','Artificer'),
('Far Step','Sorcerer'),
('Far Step','Warlock'),
('Far Step','Wizard'),
('Hold Monster','Bard'),
('Hold Monster','Sorcerer'),
('Hold Monster','Warlock'),
('Hold Monster','Wizard'),
('Raise Dead','Bard'),
('Raise Dead','Cleric'),
('Raise Dead','Paladin'),
('Wrath of Nature','Druid'),
('Wrath of Nature','Ranger'),
('Druid Grove','Druid'),
('Mental Prison','Sorcerer'),
('Mental Prison','Warlock'),
('Mental Prison','Wizard'),
('True Seeing','Bard'),
('True Seeing','Cleric'),
('True Seeing','Sorcerer'),
('True Seeing','Warlock'),
('True Seeing','Wizard'),
('Divine Word','Cleric'),
('Etherealness','Bard'),
('Etherealness','Cleric'),
('Etherealness','Sorcerer'),
('Etherealness','Warlock'),
('Etherealness','Wizard'),
('Plane Shift','Cleric'),
('Plane Shift','Druid'),
('Plane Shift','Sorcerer'),
('Plane Shift','Warlock'),
('Plane Shift','Wizard'),
('Power Word Pain','Sorcerer'),
('Power Word Pain','Warlock'),
('Power Word Pain','Wizard'),
('Resurrection','Bard'),
('Resurrection','Cleric'),
('Antimagic Field','Cleric'),
('Antimagic Field','Wizard'),
('Holy Aura','Cleric'),
('Maze','Wizard'),
('Illusory Dragon','Wizard'),
('Mighty Fortress','Wizard'),
('Astral Projection','Cleric'),
('Astral Projection','Warlock'),
('Astral Projection','Wizard'),
('Blade of Disaster','Sorcerer'),
('Blade of Disaster','Warlock'),
('Blade of Disaster','Wizard'),
('Gate','Cleric'),
('Gate','Sorcerer'),
('Gate','Wizard'),
('Meteor Swarm','Sorcerer'),
('Meteor Swar,','Wizard'),
('True Resurrection','Druid'),
('True Resurrection','Cleric');

END;
