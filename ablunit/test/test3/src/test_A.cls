block-level on error undo, throw.
using OpenEdge.Core.Assert.

class test3.test_A :
    @Test.
    method public void methodName () :
        Assert:Equals('3A', '3A').
    end method.
end class.
