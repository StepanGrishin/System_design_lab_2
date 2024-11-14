-- Создание базы данных
CREATE DATABASE archdb;

-- Подключение к базе данных
\c archdb;

-- Таблица пользователей (users)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    age INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индекс для быстрого поиска по имени пользователя
CREATE INDEX IF NOT EXISTS idx_username ON users(username);

-- Таблица постов (posts), которые размещаются пользователями на стенах
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индекс для быстрого поиска постов пользователя
CREATE INDEX IF NOT EXISTS idx_user_posts ON posts(user_id);

-- Таблица сообщений (messages), отправленных между пользователями
CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    sender_id INT REFERENCES users(id) ON DELETE CASCADE,
    receiver_id INT REFERENCES users(id) ON DELETE CASCADE,
    body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индексы для быстрого поиска сообщений между пользователями
CREATE INDEX IF NOT EXISTS idx_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_receiver_id ON messages(receiver_id);

-- Пример добавления тестовых данных в таблицу пользователей
INSERT INTO users (username, email, hashed_password, age) VALUES 
('admin', 'admin@example.com', '$2b$12$DFKswboZoqOSSKQn78yZMe87qgAMHsUZ.Zvqs98MIqbraZgfZeTdS', 30),
('alice', 'alice@example.com', '$2b$12$KIX/1Q0B1gYH3C8.x0ZQ1Oe1fS0f8s7H9r9a5e6q2gG1H5Xv4e5kO', 25),
('bob', 'bob@example.com', '$2b$12$D9U1Zc4F3lW4uD9gF3lW6uOe7f5s8s7H9r9a5e6q2gG1H5Xv4e5kO', 30),
('charlie', 'charlie@example.com', '$2b$12$A3L2F0Q0B1gYH3C8.x0ZQ1Oe1fS0f8s7H9r9a5e6q2gG1H5Xv4e5kO', 22);

-- Пример добавления тестовых данных в таблицу постов
INSERT INTO posts (user_id, content) VALUES
(1, 'Привет, мир! Это первый пост.'),
(2, 'Вот и я! Всем привет!'),
(3, 'Люблю программировать.'),
(4, 'Сегодня отличный день для обучения!');

-- Пример добавления тестовых данных в таблицу сообщений
INSERT INTO messages (sender_id, receiver_id, body) VALUES
(1, 2, 'Привет'),
(2, 1, 'Когда в клуб?'),
(3, 4, 'Да хз'),
(4, 3, 'Верни деньги!');

