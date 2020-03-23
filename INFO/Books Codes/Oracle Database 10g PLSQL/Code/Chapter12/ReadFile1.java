/*
 * ReadFile1.java
 * Chapter 12, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates how to read a file in Java.
 * It is designed as a Java library file for an Oracle
 * database stored library.
 */

// Class imports.
import java.io.*;

// Class defintion.
public class ReadFile1
{
  // Define readString() method with String input.
  public static String readString(String s)
  {
    // Call the readString() method with File input.
    return readFileString(new File(s));
  }

  // Define readFileString() method with File input.
  private static String readFileString(File file)
  {
    // Define a int to read the file.
    int c;

    // Define a String to return the text.
    String s = new String();

    // Define a FileReader.
    FileReader inFile;

    // Use a try-catch block because FileReader requires it.
    try
    {
      // Assign the file.
      inFile = new FileReader(file);

      // Read a character at a time.
      while ((c = inFile.read()) != -1)
      {
        // Append a character to the string.
        s += (char) c;

      } // End of while loop.

    } // End of try block.
    catch (IOException e)
    {
      // Return the error.
      return e.getMessage();

    } // End of catch block.

    // Return the string.
    return s;

  } // End of readFileString() method.

  // Define the main() method.
  public static void main(String[] args)
  {
    // Define the file name.
    String file = new String("/tmp/file.txt");

    // Output the string.
    System.out.println(ReadFile1.readString(file));

  } // End of main() method.

} // End of ReadFile class.
