block-level on error undo, throw.
using OpenEdge.Core.Assert.

class src.test_A :
    @Test.
    method public void methodName () :
        Assert:Equals('3A', '3A').
    end method.
end class.
