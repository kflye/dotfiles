// See https://aka.ms/new-console-template for more information

Console.WriteLine("Hello, World!");

int i = 0;

var reason = RejectionReason.MeteringPointNotIdentifiable;
i++;

var b = 0;
var c = 0;

var f = new Foo();

f.Do("hello ", "world!");

public class Foo
{
    public string Do(string a, string b)
    {
        return a + b;
    }
}

public interface IEnumerationType<out T> where T : IEnumerationType<T>
{
    static abstract T Parse(string value);
    string Value { get; }
}

public record RejectionReason() : IEnumerationType<RejectionReason>
{
    public static readonly RejectionReason MeteringPointNotIdentifiable = new RejectionReason("E10");

    public string Value { get; }

    private RejectionReason(string value) : this()
    {
        Value = value;
    }

    public static RejectionReason Parse(string value)
    {
        return new RejectionReason(value);
    }
}

public record AnswerReason() : IEnumerationType<AnswerReason>
{
    private AnswerReason(string value) : this()
    {
        Value = value;
    }

    public static AnswerReason Parse(string value)
    {
        return new AnswerReason(value);
    }
    
    public string Value { get; }
}
