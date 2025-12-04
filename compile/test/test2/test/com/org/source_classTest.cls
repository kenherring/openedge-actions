block-level on error undo, throw.
using OpenEdge.Core.Assert.

class com.org.source_class :

    @Test.
    method public void methodName () :
        Assert:Equals(1, 2).
    end method.
end class.
