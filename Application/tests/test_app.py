import unittest
from app import app

class TestApp(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()

    def test_index_route(self):
        response = self.app.get('/movies')
        self.assertEqual(response.status_code, 200)

    def test_actors_route(self):
        response = self.app.get('/actors')
        self.assertEqual(response.status_code, 200)

    def test_home_route(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
