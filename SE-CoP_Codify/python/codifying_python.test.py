import unittest
from unittest.mock import patch
from python.codifying_python import read_algorithm_table

class TestCodifyingPython(unittest.TestCase):
    
    @patch('codifying_python.connect_to_database')
    def test_read_algorithm_table(self, mock_connect):
        mock_cursor = mock_connect.return_value.cursor.return_value
        mock_cursor.fetchall.return_value = [(1, 'Algorithm 1', 'file1.py'), (2, 'Algorithm 2', 'file2.py')]
        read_algorithm_table()
        mock_connect.assert_called_once()
        mock_cursor.execute.assert_called_once_with("SELECT id, algorithm_name, algorithm_file_locator FROM Algorithm LIMIT 1000")
        mock_cursor.fetchall.assert_called_once()
    