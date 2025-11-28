message 'propath=' + propath.
define variable ablunitcore_path as character no-undo.
ablunitcore_path = search('ABLUnitCore.p').
message 'search(ABLUnitCore.p)=' + ablunitcore_path.

if ablunitcore_path = ? then
do:
    message 'ERROR: ABLUnitCore.p not found in propath'.
    session:exit-code = 1.
    quit.
end.
