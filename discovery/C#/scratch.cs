// Polymorphism
using System;
using System.Collections.Generic;
using System.Linq;

class Animal // Base class (parent)
{
    public virtual void animalSound()
    {
        Console.WriteLine("The animal makes a sound...");
    }
}

class Wolf : Animal // Derived class (child)
{
    public override void animalSound()
    {
        Console.WriteLine("The wolf growls");
    }
}

class Dog : Animal // Derived class (child)
{
    public override void animalSound()
    {
        Console.WriteLine("The dog barks");
    }
}

class Program
{
    static void Main(string[] args)
    {
        Animal myAnimal = new Animal(); //Create an Animal object
        Animal myWolf = new Wolf();     //Create a Wolf object
        Animal myDog = new Dog();       //Create a Dog object

        myAnimal.animalSound();
        myWolf.animalSound();
        myDog.animalSound();
    }
}

// With Dictionary
// LINQ is shorter and handier
public static int MostPopularFramework(string[] frameworks)
{
    var counts = new Dictionary<string, int>();

    int occurences = 0;

    foreach (var framework in frameworks)
    {
        int count;

        counts.TryGetValue(framework, out count);

        count++;

        counts[framework] = count;
    }

    string mostPopular = null;

    foreach (var pair in counts)
    {
        if (pair.Value > occurences)
        {
            occurences = pair.Value;

            mostPopular = pair.Key;
        }
    }

    Console.WriteLine("The most popular framework is {0}, and it appears {1} times.",
        mostPopular, occurences);

    return occurences;
}

// using System;
// using System.Collections.Generic;
// using System.Linq;

public class Program
{
    public static void Main()
    {
        foreach (var i in Fibonacci().Take(20))
        {
            Console.WriteLine(i);
        }
    }

    private static IEnumerable<int> Fibonacci()
    {
        int current = 1, next = 1;

        while (true)
        {
            yield return current;
            
            next = current + (current = next);
        }
    }
}

public class Program
{
    public static void Main()
    {
        List<string> frameWorks = new List<string>() 
            { "HIPPA", "SOC2", "SOC3", "SOC2", "HIPPA", "GDPR", "GDPR", "ISO", "HIPPA", "GDPR", "HIPPA" };

        frameWorks.ForEach(frame => Console.WriteLine(frame));

        foreach (var frame in frameWorks)
            Console.WriteLine(frame);

        for(int i=0; i < frameWorks.Count; i++)
            Console.WriteLine(frameWorks[i]);
    }
}

class SuperClass
{
    static void Main(String[] frames)
    {
        // Create array.
        string [] arr = {
            "HIPPA", "SOC2", "SOC3", "SOC2", "HIPPA", "GDPR", "GDPR", "ISO", "HIPPA", "GDPR", "HIPPA"
        };

        String results = mostPopular(arr);

        // Print most popular framework.
        Console.WriteLine(results);
    }

    static String mostPopular(String[] arr)
    {
        // Create the Dictionary.
        Dictionary<String, int> fw = 
            new Dictionary<String, int>();

        // Begin iterations.
        for (int i =0; i < arr.Length; i++)
        {
            if (fw.ContainsKey(arr[i]))
            {
                fw[arr[i]] = fw[arr[i]] + 1;
            }
            else {
                fw.Add(arr[i], 1);
            }
        }

        // Create set to iterate.
        String key = "";
        int value = 0;

        foreach(KeyValuePair<String, int> me in fw)
        {
            if (me.Value > value)
            {
                value = me.Value;
                key = me.Key;
            }
        }

        // Return the most popular framework from the array list.
        return key;
    }
}

int length = Math.Max(arr[i]);

Console.WriteLine("Top frameworks in decending order:");
if (String.Compare())

/*
A class or struct definition is like a blueprint that specifies 
what the type can do. 

An object is basically a block of memory that has been 
allocated and configured according to the blueprint. 

A program may create many objects of the same class. 

Objects are also called instances, and they can be stored in 
either a named variable or in an array or collection. 

Client code is the code that uses these variables to call the 
methods and access the public properties of the object. 

In an object-oriented language such as C#, a typical 
program consists of multiple objects interacting dynamically.
*/

#region DevMSSWindows
// Create C# apps using SQL Server on Windows
using System;
using System.Linq;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace SqlServerEFSample
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("** C# CRUD sample with Entity Framework and SQL Server **\n");
            try
            {
                // Build connection string
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
                builder.DataSource = "localhost";   // update me
                builder.UserID = "sa";              // update me
                builder.Password = "your_password";      // update me
                builder.InitialCatalog = "EFSampleDB";

                using (EFSampleContext context = new EFSampleContext(builder.ConnectionString))
                {
                    Console.WriteLine("Created database schema from C# classes.");

                    // Create demo: Create a User instance and save it to the database
                    User newUser = new User { FirstName = "Anna", LastName = "Shrestinian" };
                    context.Users.Add(newUser);
                    context.SaveChanges();
                    Console.WriteLine("\nCreated User: " + newUser.ToString());

                    // Create demo: Create a Task instance and save it to the database
                    Task newTask = new Task() { Title = "Ship Helsinki", IsComplete = false, DueDate = DateTime.Parse("04-01-2017") };
                    context.Tasks.Add(newTask);
                    context.SaveChanges();
                    Console.WriteLine("\nCreated Task: " + newTask.ToString());

                    // Association demo: Assign task to user
                    newTask.AssignedTo = newUser;
                    context.SaveChanges();
                    Console.WriteLine("\nAssigned Task: '" + newTask.Title + "' to user '" + newUser.GetFullName() + "'");

                    // Read demo: find incomplete tasks assigned to user 'Anna'
                    Console.WriteLine("\nIncomplete tasks assigned to 'Anna':");
                    var query = from t in context.Tasks
                                where t.IsComplete == false &&
                                t.AssignedTo.FirstName.Equals("Anna")
                                select t;
                    foreach (var t in query)
                    {
                        Console.WriteLine(t.ToString());
                    }

                    // Update demo: change the 'dueDate' of a task
                    Task taskToUpdate = context.Tasks.First(); // get the first task
                    Console.WriteLine("\nUpdating task: " + taskToUpdate.ToString());
                    taskToUpdate.DueDate = DateTime.Parse("06-30-2016");
                    context.SaveChanges();
                    Console.WriteLine("dueDate changed: " + taskToUpdate.ToString());

                    // Delete demo: delete all tasks with a dueDate in 2016
                    Console.WriteLine("\nDeleting all tasks with a dueDate in 2016");
                    DateTime dueDate2016 = DateTime.Parse("12-31-2016");
                    query = from t in context.Tasks
                            where t.DueDate < dueDate2016
                            select t;
                    foreach (Task t in query)
                    {
                        Console.WriteLine("Deleting task: " + t.ToString());
                        context.Tasks.Remove(t);
                    }
                    context.SaveChanges();

                    // Show tasks after the 'Delete' operation - there should be 0 tasks
                    Console.WriteLine("\nTasks after delete:");
                    List <Task> tasksAfterDelete = (from t in context.Tasks select t).ToList <Task> ();
                    if (tasksAfterDelete.Count == 0)
                    {
                        Console.WriteLine("[None]");
                    }
                    else
                    {
                        foreach (Task t in query)
                        {
                            Console.WriteLine(t.ToString());
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            Console.WriteLine("All done. Press any key to finish...");
            Console.ReadKey(true);
        }
    }
}
//F5 build

//User.cs
//using System;
//using System.Collection.Generic;

namespace SqlServerEFSample
{
    public class User
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public String LastName { get; set; }
        public virtual IList<Task> Tasks { get; set; }

        public String GetFullName()
        {
            return.this.FirstName + " " + this.LastName;
        }
        public override string ToString()
        {
            return "User [id=" + this.UserId + ", name=" + this.GetFullName() + "]";
        }
    }
}

//Task.cs
//using System;

namespace SqlServerEFSample
{
    public class Task
    {
        public int TaskId { get; set; }
        public string Title { get; set; }
        public DateTime DueDate { get; set; }
        public bool IsComplete { get; set; }
        public virtual User AssignedTo { get; set; }

        public override string ToString()
        {
            return "Task [id=" + this.TaskId + ", title=" + this.Title + ", dueDate=" + this.DueDate.ToString() + ", IsComplete=" + this.IsComplete + "]";
        }
    }
}

//EFSampleContext.cs
//using System;
//using System.Data.Entity;

namespace SqlServerEFSample
{
    public class EFSampleContext : DbContext
    {
        public EFSampleContext(string connectionString)
        {
            Database.SetInitializer<EFSampleContext>(new DropCreateDatabaseAlways<EFSampleContext>());
        }
        public DbSet<User> Users { get; set; }
        public DbSet<Task> Tasks { get; set; }
    }
}

//https://sqlchoice.azurewebsites.net/en-us/sql-server/developer-get-started/csharp/win/step/3.html

#endregion