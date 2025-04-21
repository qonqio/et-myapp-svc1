namespace Contoso.Service1.Tests
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