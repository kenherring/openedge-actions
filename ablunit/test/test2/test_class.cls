block-level on error undo, throw.
using OpenEdge.Core.Assert.

class test.test2.test_class:
    @Test.
    method public void methodName_pass () :
        Assert:Equals(1, 1).
    end method.

    @Ignore.
    @Test.
    method public void methodName_fail () :
        Assert:Equals(1, 2).
    end method.
end class.
