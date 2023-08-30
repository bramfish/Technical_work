using System;
using System.IO;

class Program {
    static void Main(string[] args) {
        string filePath = "Algorithm.csv";
        string searchKeyword = "Association rules";
        string[] algorithmNames = ReadCsvFile(filePath);
        string algorithmFileLocator = SearchAlgorithmName(algorithmNames, searchKeyword);
        Console.WriteLine(algorithmFileLocator);
    }

    static string[] ReadCsvFile(string filePath) {
        string[] algorithmNames = null;
        try {
            algorithmNames = File.ReadAllLines(filePath);
        } catch (Exception e) {
            Console.WriteLine("Error: " + e.Message);
        }
        return algorithmNames;
    }

    static string SearchAlgorithmName(string[] algorithmNames, string searchKeyword) {
        string algorithmFileLocator = null;
        for (int i = 1; i < algorithmNames.Length; i++) {
            string[] algorithmDetails = algorithmNames[i].Split(',');
            if (algorithmDetails[0].Contains(searchKeyword)) {
                algorithmFileLocator = algorithmDetails[1];
                break;
            }
        }
        return algorithmFileLocator;
    }
}
