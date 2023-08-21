# Flask web application
from flask import Flask, render_template, jsonify
import psycopg2
import os
import base64

app = Flask(__name__)

class Film:
    def __init__(self, f_id, f_name, f_producer, f_director, f_prizes, f_year, f_rating, f_count_rating, f_type):
        self.f_id = f_id
        self.f_name = f_name
        self.f_producer = f_producer
        self.f_director = f_director
        self.f_prizes = f_prizes
        self.f_year = f_year
        self.f_rating = f_rating
        self.f_count_rating = f_count_rating
        self.f_type = f_type

    def __str__(self):
        return (
            f"Film ID: {self.f_id}\n"
            f"Film Name: {self.f_name}\n"
            f"Producer: {self.f_producer}\n"
            f"Director: {self.f_director}\n"
            f"Prizes: {self.f_prizes}\n"
            f"Year: {self.f_year}\n"
            f"Rating: {self.f_rating}\n"
            f"Count of Ratings: {self.f_count_rating}\n"
            f"Film Type: {self.f_type}"
        )

class Actor:
    def __init__(self, a_id, a_name, a_lastname, a_gender):
        self.a_id = a_id
        self.a_name = a_name
        self.a_lastname = a_lastname
        self.a_gender = a_gender

    def __str__(self):
        return (
            f"Actor ID: {self.a_id}\n"
            f"First Name: {self.a_name}\n"
            f"Last Name: {self.a_lastname}\n"
            f"Gender: {self.a_gender}"
        )

def decode_base64(encoded_string):
    try:
        decoded_bytes = base64.b64decode(encoded_string)
        decoded_string = decoded_bytes.decode('utf-8')
        print(decoded_string)
        return decoded_string
    except Exception as e:
        return str(e)

# Replace the following with your PostgreSQL database connection details
db_connection_config = {
    'host': os.environ.get('DB_HOST', 'postgresdb.database.svc.cluster.local'),
    'database': decode_base64(os.environ.get('DB_DATABASE', 'bW92aWVzREI=')),
    'user': decode_base64(os.environ.get('DB_USER', 'cG9zdGdyZXM=')),
    'password': decode_base64(os.environ.get('DB_PASSWORD', 'c3FsQWRtaW4='))
}

@app.route('/movies')
def index():
    try:
        # Establish a connection to the PostgreSQL database
        conn = psycopg2.connect(**db_connection_config)
        
        # Create a cursor to interact with the database
        cursor = conn.cursor()

        # Query all movies from the 'movies' table
        cursor.execute("SELECT * FROM public.films;")
        rows = cursor.fetchall()

        films = []

        # Assuming rows contain data retrieved from the database
        for row in rows:
            f_id, f_name, f_producer, f_director, f_prizes, f_year, f_rating, f_count_rating, f_type = row
            film = Film(f_id, f_name, f_producer, f_director, f_prizes, f_year, f_rating, f_count_rating, f_type)
            films.append(film)

        # Close the cursor and connection
        cursor.close()
        conn.close()

        return render_template('movies.html', films=films)
    except Exception as e:
        return f"Error: {e}"

@app.route('/actors')
def actors():
    try:
        # Establish a connection to the PostgreSQL database
        conn = psycopg2.connect(**db_connection_config)

        # Create a cursor to interact with the database
        cursor = conn.cursor()

        # Query all actors/actresses from the 'actors' table
        cursor.execute("SELECT * FROM public.actors;")
        actor_rows = cursor.fetchall()

        # Create a list to store actor objects
        actors = []
        for row in actor_rows:
            a_id, a_name, a_lastname, a_gender = row
            actor = Actor(a_id, a_name, a_lastname, a_gender)
            actors.append(actor)

        # Close the cursor and connection
        cursor.close()
        conn.close()

        return render_template('actors.html', actors=actors)
    except Exception as e:
        return f"Error: {e}"

@app.route('/' , methods=["GET"])
def home():
    return render_template("Film_Library.html")

@app.route('/ping', methods=["GET"])
#test
def test():
    response = {
        'status': 'success',
        'massage' : 'PONG'
    }
    return jsonify(response)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
