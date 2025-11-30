log-manager:write-message("getting customerCount...").
define variable customerCount as integer no-undo.
for each customer no-lock:
    customerCount = customerCount + 1.
end.
log-manager:write-message("customerCount=" + string(customerCount)).
