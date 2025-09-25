-- Seed sample schema for SQL learning path smoke tests
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  category_id INT,
  price NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

INSERT INTO categories (name) VALUES ('Books') ON CONFLICT DO NOTHING;
INSERT INTO categories (name) VALUES ('Electronics') ON CONFLICT DO NOTHING;

INSERT INTO products (name, category_id, price) VALUES
('Intro to SQL', 1, 19.99),
('Advanced SQL', 1, 29.99),
('USB Cable', 2, 4.99)
ON CONFLICT DO NOTHING;
