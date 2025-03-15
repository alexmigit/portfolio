using System;

// Entity Framework class
public class ContosoContext : DbContext
{
    public ContosoContext()
        : base(@"Data Source=(localdb)\MSSQLLOCALDB;Initial catalog=ContosoDB;")
    {}

    public virtual Dbset<Partner> Partners { get; set; }
}

// Create interface for common needs from context class
public interface IContosoContext : IDisposable
{
    DbSet<Partner> Partners { get; }
    int SaveChanges();
}

// Apply above interface to existing context class
public class HomeController : HomeController
{
    private readonly IContosoContext _context;

    public HomeController(IContosoContext context)
    {
        _context = context;
    }
}

// Create TEST double for IContosoContext interface
public class TextContosoContext : IContosoContext
{
    public DbSet<Partner> Partners { get; set; }

    public int SaveChanges()
    {
        return 0;
    }

    public void Dispose()
    { }
}

// Mocking Entity Framework
public class TextContosoContext : IContosoContext
{
    public TestContosoContext()
    {
        this.Partners = new TestDbSet<Partner>();
    }

    public DbSet<Partner> Partners { get; set; }

    public int SaveChanges()
    {
        return 0;
    }

    public void Dispose()
    { }
}