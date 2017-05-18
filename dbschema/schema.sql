DROP TABLE IF EXISTS sub_faculty;
DROP TABLE IF EXISTS profession;
DROP TABLE IF EXISTS group_st;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS relative;
DROP TABLE IF EXISTS abroad;
DROP TABLE IF EXISTS lecturer;
DROP TABLE IF EXISTS enterprise;
DROP TABLE IF EXISTS representative;
DROP TABLE IF EXISTS var_assignment;
DROP TABLE IF EXISTS assignment;
DROP TABLE IF EXISTS payment;


CREATE TABLE sub_faculty (
    id INTEGER PRIMARY KEY, 
    nomer INTEGER NOT NULL,
    name TEXT NOT NULL
);

CREATE TABLE profession (
    id INTEGER PRIMARY KEY, 
    nomer INTEGER NOT NULL,
    name TEXT NOT NULL, 
    sub_fac_id INTEGER NOT NULL,
    UNIQUE (nomer, name, sub_fac_id) ON CONFLICT REPLACE,
    FOREIGN KEY (sub_fac_id) REFERENCES sub_faculty (id) ON DELETE CASCADE
);

CREATE TABLE group_st (
    id INTEGER PRIMARY KEY, 
    nomer TEXT NOT NULL, 
    sub_fac_id INTEGER NOT NULL,
    UNIQUE (nomer),
    FOREIGN KEY (sub_fac_id) REFERENCES sub_faculty (id) ON DELETE CASCADE
);

CREATE TABLE student (
    id INTEGER PRIMARY KEY, 
    surname TEXT NOT NULL, 
    name TEXT not null, 
    sex TEXT NOT NULL CHECK( sex in ('M', 'F')),
    birthday TEXT NOT NULL,
    nationality TEXT NOT NULL,
    address TEXT NOT NULL,
    mark REAL NOT NULL,
    group_id INTEGER NOT NULL,
    FOREIGN KEY (group_id) REFERENCES group_st (id) ON DELETE CASCADE
);

CREATE TABLE relative (
    id INTEGER PRIMARY KEY,
    surname TEXT NOT NULL,
    name TEXT NOT NULL,
    rodstvo TEXT NOT NULL,
    address TEXT NOT NULL,
    work_place TEXT,
    job TEXT,
    stud_id INTEGER NOT NULL,
    FOREIGN KEY (stud_id) REFERENCES student (id) ON DELETE CASCADE
);

CREATE TABLE abroad (
    id INTEGER PRIMARY KEY,
    data TEXT NOT NULL,
    country TEXT NOT NULL,
    rel_id INTEGER NOT NULL,
    FOREIGN KEY (rel_id) REFERENCES relative (id) ON DELETE CASCADE
);

CREATE TABLE lecturer (
    id INTEGER PRIMARY KEY,
    surname TEXT NOT NULL,
    name TEXT NOT NULL, 
    sub_fac_id INTEGER NOT NULL,
    FOREIGN KEY (sub_fac_id) REFERENCES sub_faculty (id) ON DELETE CASCADE
);

CREATE TABLE enterprise (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    UNIQUE (name, address)
);

CREATE TABLE representative (
    id INTEGER PRIMARY KEY,
    surname TEXT NOT NULL,
    name TEXT NOT NULL,
    job TEXT NOT NULL,
    ent_id INTEGER NULL,
    FOREIGN KEY(ent_id) REFERENCES enterprise(id)
);

CREATE TABLE var_assignment (
    id INTEGER PRIMARY KEY,
    data_talk TEXT NOT NULL,
    stud_id INTEGER NOT NULL,
    repres_id INTEGER NOT NULL,
    lect_id INTEGER NOT NULL,
    ent_id INTEGER NOT NULL,
    FOREIGN KEY (stud_id)   REFERENCES student (id) ON DELETE CASCADE,
    FOREIGN KEY (repres_id) REFERENCES representative (id) ON DELETE CASCADE,
    FOREIGN KEY (lect_id)   REFERENCES lecturer (id) ON DELETE CASCADE,
    FOREIGN KEY (ent_id)    REFERENCES enterprise (id) ON DELETE CASCADE
);

CREATE TABLE assignment (
    id INTEGER PRIMARY KEY,
    data_contr TEXT NOT NULL,
    data_work INTEGER NOT NULL,
    var_assig_id INTEGER NOT NULL,
    FOREIGN KEY (var_assig_id) REFERENCES var_assignment (id) ON DELETE CASCADE
);

CREATE TABLE payment (
    id INTEGER PRIMARY KEY,
    data TEXT NOT NULL,
    summa INTEGER NOT NULL,
    assig_id INTEGER NOT NULL,
    FOREIGN KEY (assig_id) REFERENCES assignment (id) ON DELETE CASCADE
);



INSERT INTO sub_faculty(id, nomer, name) VALUES 
(100, 43, 'Кафедра "Стратегические информационные исследования"'),
(101, 12, 'Кафедра "Компьютерные системы и технологии"'),
(102,  1, 'Кафедра "Биофизика, радиационная физика и экология"'),
(103,  2, 'Кафедра автоматики');


INSERT INTO profession(id, nomer, name, sub_fac_id) VALUES
(100, 200600, 'Электроника и автоматика физических установок', 103), 
(101,  70400, 'Физика пучков заряженных частиц и ускорительная техника', 103),
(102,  75400, 'Комплексная защита объектов информации', 100),
(103,  75500, 'Комплексное обеспечение информационной безопасности автоматизированных систем', 100),
(104,  10200, 'Прикладная математика и информатика', 101),
(105,  73000, 'Прикладная математика', 101),
(106, 220100, 'Вычислительные машины, комплексы, системы и сети', 101),
(107, 220200, 'Автоматизированные системы обработки информации и управления', 101),
(108,  10200, 'Прикладная математика и информатика', 102),
(109,  14000, 'Медицинская физика', 102),
(110,  14300, 'Физика Земли и планет', 102),
(111,  72600, 'Физика конденсированного состояния вещества', 102),
(112,  72700, 'Физика атомного ядра и частиц', 102),
(113, 330300, 'Радиационная безопасность человека и окружающей среды', 102);


INSERT INTO group_st(id, nomer, sub_fac_id) VALUES
(100, 'Б8-01', 100),
(101, 'Б8-02', 100),
(102, 'Б8-03', 100),
(103, 'К8-122', 101),
(104, 'К8-121', 101),
(105, 'К8-123', 101),
(106, 'К8-124', 101),
(107, 'Т8-07', 102),
(108, 'Т8-11', 102),
(109, 'Т8-12', 102),
(110, 'А8-01', 103),
(111, 'А8-02', 103);


INSERT INTO lecturer(id, surname, name, sub_fac_id) VALUES
(100, 'Зайцев', 'Михаил', 100),
(101, 'Васильев', 'Николай', 101),
(102, 'Левкин', 'Федор', 102),
(103,  'Зубов', 'Роман', 103);


INSERT INTO enterprise(id, name, address) VALUES
(100,   'МосКом',       'ул.Папанина,34'),
(101,   'Ланит',        'ул.Савельева,15'),
(102,   'ОКБ САПР',     'ул.Самаринская,1/А'),
(103,   'ЦБ России',    'Угловой пер.,3'),
(104,   'НИИ "Квант"',  'ул.Гоголя,4'),
(105,   'Лаборатория Касперского', 'ул.Ибрагимова,22'),
(106,   'БиЛайн',       'Извилистый пр.,12'),
(107,   'Мегафон',      'ул.Макеевская,5'),
(108,   'МТС',          'ул.Народная,10'),
(109,   'НИИ "Гидропроект"',   'ул.Богданова,2'),
(110,   'ОАО "Азбука Морзе"',  'ул.Веерная,31');


INSERT INTO representative(id, surname, name, job, ent_id) VALUES
(100,	'Кулаков',	'Петр',		'',	100),
(101,	'Леонов',	'Василий',	'',	101),
(102,	'Лохмаев',	'Роман',	'',	102),
(103,	'Быкадоров',     'Игорь',	'',	103),
(104,	'Семенов',	'Евгений',	'',	103),
(105,	'Забелин',	'Дмитрий',	'',	104),
(106,	'Ходько',	'Алексей',	'',	105),
(107,	'Демин',	'Петр',		'',	106),
(108,	'Филаретов',    'Михаил',	'',	107),
(109,	'Стоин',	'Владимир',	'',	108),
(110,	'Минаев',	'Семен',	'',	110);


INSERT INTO student(id, surname, name, sex, birthday, nationality, address, mark, group_id) VALUES
(100,	'Петров',	'Алексей',	'M',	'1984-03-12',	'Русский',	'ул.Хлобыстова, д.9, кв.43',	4.5,	100),
(101,	'Пупкин',	'Андрей',	'M',	'1984-01-14',	'Русский',	'ул.Горького, д.1, кв.4',	4.9,	100),
(102,	'Сидоров',	'Илья',	'M',	'1984-01-01',	'Русский',	'ул.Косякова, д.2, кв.1',	3.01,	100),
(103,	'Алиев',	'Александр',	'M',	'1984-12-10',	'Грузин',	'ул.Дачная, д.13, кв.12',	3.5,	101),
(104,	'Иванов',	'Иван',	'M',	'1983-11-03',	'Русский',	'ул.Гоголя, д.15, кв.110',	3.89,	101),
(105,	'Левин',	'Дмитрий',	'M',	'1984-07-28',	'Русский',	'ул.Зеленая, д.11, кв.11',	3.67,	101),
(106,	'Огнев',	'Евгений',	'M',	'1984-03-31',	'Русский',	'ул.Калинина, д.16, кв.1',	3.34,	102),
(107,	'Павлова',	'Анна',	'F',	'1983-06-25',	'Русская',	'ул.Казинская, д.4, кв.23',	4.8,	102),
(108,	'Глотова',	'Ольга',	'F',	'1984-04-17',	'Русская',	'ул.Икшинская, д.10, кв.3',	3.31,	102),
(109,	'Соснова',	'Мария',	'F',	'1984-12-13',	'Русская',	'Юрловский пр, д.1А, кв.15',	3.92,	103),
(110,	'Шарафутдинов',	'Сергей',	'M',	'1984-02-02',	'Русский',	'ул.Ягодная, д.12, кв.99',	4.47,	103),
(111,	'Копылов',	'Сергей',	'M',	'1984-08-07',	'Русский',	'ул.Грина, д.8, кв.45',	4.51,	103),
(112,	'Баженова',	'Анна',	'F',	'1984-10-04',	'Русская',	'ул.Элеваторная, д.17, кв.5',	3.15,	104),
(113,	'Козлов',	'Игорь',	'M',	'1984-10-11',	'Поляк',	'Луков пер., д.8, кв.75',	4.06,	104),
(114,	'Кудашев',	'Алексей',	'M',	'1984-02-13',	'Русский',	'ул.Дальняя, д.3, кв.45',	4.78,	104),
(115,	'Казарина',	'Анна',	'F',	'1984-01-31',	'Русская',	'ул.Довженко, д.32, кв.4',	3.25,	105),
(116,	'Сечин',	'Алексей',	'M',	'1983-12-31',	'Русский',	'ул.Забелина, д.14, кв.42',	5,	105),
(117,	'Лактанова',	'Ольга',	'F',	'1985-02-01',	'Русская',	'ул.Зональная, д.22, кв.15',	4.82,	106),
(118,	'Обищан',	'Ксения',	'F',	'1984-07-09',	'Русская',	'ул.Раевского, д.1, кв.78',	3.45,	106),
(119,	'Болдырев',	'Александр',	'M',	'1982-06-13',	'Русский',	'ул.Ротерта, д.2, кв.65',	3.19,	107),
(120,	'Чижов',	'Максим',	'M',	'1984-07-24',	'Русский',	'Рыбный пер., д.2, кв.16',	4.48,	107),
(121,	'Чигарева',	'Ирина',	'F',	'1984-08-12',	'Русская',	'ул.Жигулевская, д.24, кв.10',	4.54,	108),
(122,	'Воронцова',	'Екатерина',	'F',	'1983-08-22',	'Русская',	'ул.Обручева, д.11, кв.85',	4.96,	108),
(123,	'Измайлов',	'Владимир',	'M',	'1984-12-16',	'Русский',	'Ореховый пр., д.15, кв.34',	3.4,	109),
(124,	'Хорин',	'Олег',	'M',	'1984-04-29',	'Русский',	'ул.Отрадная, д.21, кв.2',	3.8,	109),
(125,	'Бабайлова',	'Нина',	'F',	'1984-04-10',	'Русская',	'ул.Федорова, д.19, кв.64',	4.33,	109),
(126,	'Харитонов',	'Павел',	'M',	'1983-05-04',	'Русский',	'ул.Фонвизина, д.18, кв.14',	4.44,	109),
(127,	'Воробьев',	'Дмитрий',	'M',	'1984-01-02',	'Русский',	'Тарный пр., д.2, кв.278',	3.66,	110),
(128,	'Лимонов',	'Леонид',	'M',	'1985-08-11',	'Русский',	'ул.Толбухина,д.5,кв.33',	3.9,	110),
(129,	'Печкина',	'Оксана',	'F',	'1984-09-09',	'Русская',	'ул.Тушинская,д.6,кв.49',	4.02,	111),
(130,	'Яшин',	'Сергей',	'M',	'1984-09-19',	'Русский',	'ул.Бажова,д.7,кв.75',	4.59,	111);



INSERT INTO relative(id, surname, name, rodstvo, address, work_place, job, stud_id) VALUES
(100,	'Петров',	'Игорь',	'Отец',	'ул.Хлобыстова, д.9, кв.43',	NULL, NULL,100),
(101,	'Петрова',	'Елена',	'Мать',	'ул.Хлобыстова, д.9, кв.43',	NULL, NULL,100),
(102,	'Петров',	'Роман',	'Брат',	'ул.Хлобыстова, д.9, кв.43',	NULL, NULL,100),
(103,	'Пупкин',	'Кирилл',	'Отец',	'ул.6 Парковая, д.11, кв.7',	'ЗАО СвязьСтройСервис',	NULL, 101),
(104,	'Пупкина',	'Марина',	'Мать',	'ул.6 Парковая, д.11, кв.7',	NULL, NULL, 101),
(105,	'Иванов',	'Иван',	'Отец',	'ул.Цандера, д.23, кв.3',	'в/ч 19674',	'Военнослужащий',	104),
(106,	'Иванова',	'Ирина',	'Мать',	'ул.Цандера, д.23, кв.3',	'в/ч 19674',	'Военнослужащая',	104),
(107,	'Павлов',	'Леонид',	'Отец',	'ул.Казинская, д.4, кв.23',	'МГУ',	'Декан',	107),
(108,	'Павлова',	'Мария',	'Мать',	'ул.Казинская, д.4, кв.23',	NULL, NULL, 107),
(109,	'Шарафутдинов',	'Николай',	'Отец',	'ул.Ягодная, д.12, кв.99',	'ЦБ России', 	NULL, 110),
(110,	'Шарафутдинова',	'Вера',	'Мать',	'ул.Ягодная, д.12, кв.99',	'МСЧ',	'Медсестра',	110),
(111,	'Шарафутдинова',	'Анастасия',	'Сестра',	'ул.Ягодная, д.12, кв.99',	'Школа №345',	'Ученица 7класса',	110),
(112,	'Шарафутдинов',	'Евгений',	'Брат',	'ул.Ягодная, д.12, кв.99',	'МАДИ',	'Студент',	110),
(113,	'Кудашева',	'Александра',	'Жена',	'ул.Палиха, д.32, кв.254',	NULL, NULL, 114),
(114,	'Казарин',	'Сергей',	'Отец',	'ул.Довженко, д.32, кв.4',	'Районная больница №12',	'Главврач',	115),
(115,	'Лактанов',	'Игорь',	'Отец',	'ул.Зональная, д.22, кв.15',	NULL, NULL, 117),
(116,	'Лактанова',	'Евгения',	'Мать',	'ул.Зональная, д.22, кв.15',	NULL, NULL, 117),
(117,	'Болдырева',	'Наталья',	'Мать',	'ул.Ротерта, д.2, кв.65',	'ОАО Грузоперевозки""',	'Оператор ПК',	119),
(118,	'Воронцов',	'Кирилл',	'Отец',	'ул.Обручева, д.11, кв.85',	NULL, NULL, 122),
(119,	'Измайлов',	'Петр',	'Отец',	'Ореховый пр., д.15, кв.34',	NULL, NULL, 123),
(120,	'Измайлова',	'Оксана',	'Мать',	'Ореховый пр., д.15, кв.34',	NULL, NULL, 123),
(121,	'Бабайлов',	'Иван',	'Отец',	'ул.Федорова, д.19, кв.64',	NULL, NULL, 125),
(122,	'Бабайлов',	'Олег',	'Брат',	'ул.Федорова, д.19, кв.64',	NULL, NULL, 125),
(123,	'Харитонов',	'Анатолий',	'Отец',	'ул.Фонвизина, д.18, кв.14',	'Школа №756',	'Учитель',	126);


INSERT INTO abroad (id, data, country, rel_id) VALUES
(100,	'1999-04-12',	'Польша',	108),
(101,	'1999-04-12',	'Польша',	109),
(102,	'2001-11-03',	'Франция',	114),
(103,	'1993-01-14',	'США',	120),
(104,	'1993-01-14',	'США',	121),
(105,	'2002-07-05',	'Испания',	123);

INSERT INTO var_assignment(id, data_talk, stud_id, repres_id, lect_id, ent_id) VALUES
(100,	'2004-12-13',	100,	101,	100,	101),
(101,	'2004-12-19',	100,	102,	100,	102),
(102,	'2004-11-01',	100,	105,	100,	105),
(103,	'2004-12-07',	103,	104,	100,	104),
(104,	'2004-10-28',	103,	109,	100,	109),
(105,	'2004-11-25',	104,	110,	100,	110),
(106,	'2004-11-14',	105,	101,	100,	101),
(107,	'2004-12-14',	105,	110,	100,	110),
(108,	'2004-10-22',	110,	104,	101,	104),
(109,	'2004-12-15',	110,	106,	101,	106),
(110,	'2004-12-16',	110,	107,	101,	107),
(111,	'2004-11-17',	110,	108,	101,	108),
(112,	'2004-10-18',	115,	105,	101,	105),
(113,	'2004-11-27',	115,	110,	101,	110),
(114,	'2004-11-09',	115,	107,	101,	107),
(115,	'2004-12-10',	120,	100,	102,	100),
(116,	'2005-01-15',	120,	101,	102,	101),
(117,	'2004-10-25',	121,	109,	102,	109),
(118,	'2004-12-23',	122,	103,	102,	103),
(119,	'2005-01-16',	129,	106,	103,	106),
(120,	'2004-12-11',	129,	108,	103,	108),
(121,	'2004-11-11',	130,	107,	103,	107),
(122,	'2004-12-04',	130,	108,	103,	108);


INSERT INTO assignment(id, data_contr, data_work, var_assig_id) VALUES
(100,	'2005-01-15',	'2005-04-01',	100),
(101,	'2005-02-25',	'2005-04-15',	103),
(102,	'2005-02-10',	'2005-04-11',	105),
(103,	'2005-03-09',	'2005-04-18',	107),
(104,	'2005-02-17',	'2005-05-29',	109),
(105,	'2005-02-14',	'2005-04-30',	112),
(106,	'2005-01-26',	'2005-05-01',	115),
(107,	'2005-03-31',	'2005-04-13',	117),
(108,	'2005-03-19',	'2005-05-03',	118),
(109,	'2005-02-22',	'2005-04-12',	120),
(110,	'2005-03-03',	'2005-04-08',	121);

INSERT INTO payment(id, data, summa, assig_id) VALUES
(100,	'2005-02-12',	2000,	100),
(101,	'2005-02-01',	3000,	103),
(102,	'2005-02-13',	1500,	104),
(103,	'2005-02-15',	1000,	106),
(104,	'2005-03-10',	3500,	109),
(105,	'2005-02-28',	2000,	110);
