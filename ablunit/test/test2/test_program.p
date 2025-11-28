block-level on error undo, throw.
using OpenEdge.Core.Assert.

@Test.
procedure procedureName_pass :
    Assert:Equals(3, 3).
end procedure.
