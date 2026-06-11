#!/bin/bash

# Go home
cd ~

# Clone repo (HTTPS so it always works)
git clone https://github.com/92usman/3-Tier-Python-Postgres-Local-main.git

# Install Python venv
sudo apt install python3.12-venv -y

# Create venv
python3 -m venv myenv
source myenv/bin/activate

# Install pip
sudo apt install python3-pip -y

# Install project requirements
cd ~/3-Tier-Python-Postgres-Local-main
pip install -r requirements.txt

# Install PostgreSQL
sudo apt-get install postgresql postgresql-contrib -y
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create DB + user + schema (non-interactive)
sudo -u postgres psql <<EOF
CREATE USER root WITH PASSWORD 'root';
CREATE DATABASE my_database;
GRANT ALL PRIVILEGES ON DATABASE my_database TO root;
\c my_database
GRANT ALL PRIVILEGES ON SCHEMA public TO root;
GRANT CREATE ON DATABASE my_database TO root;
EOF

# Activate venv again
source ~/myenv/bin/activate

# Run backend
python run.py
