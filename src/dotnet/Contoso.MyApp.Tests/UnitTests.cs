namespace Contoso.MyApp.Tests
{
    public class UnitTests
    {
        [Fact]
        [Trait("Category", "Unit")]
        public void Test1()
        {
            var isTrue = true;
            Assert.True(isTrue);
        }
    }
}