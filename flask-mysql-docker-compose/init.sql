USE mysql;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

INSERT INTO users (name, email) VALUES
('liban ali', 'lee@example.com'),
('amira ali', 'amira@example.com'),
('yusra ali', 'yusra@example.com'); 
INSERT INTO users (name, email) VALUES ('khaled ali', 'khaled@example.com');
